#
# Author:: Daniel DeLeo <dan@kallistec.com>
# Cookbook Name:: subversion
# Recipe:: server
#
# Copyright 2009, Daniel DeLeo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "apache2::mod_dav_svn"
include_recipe "subversion::client"

unless node.platform == "ubuntu" && node.platform_version.to_s == "11.10"
  apache_module "authz_svn"
end

svn_base = node['subversion']['svn_dir']
repo_base = node['subversion']['repo_base_dir']

directory repo_base do
  action :create
  recursive true
  owner node['apache']['user']
  group node['apache']['user']
  mode "0755"
end

file "#{svn_base}/htpasswd" do
  action :create
  owner "root"
  group "root"
  mode "0644"
end

web_app "subversion" do
  template "subversion.conf.erb"
  server_name "#{node['subversion']['server_name']}.#{node['domain']}"
  notifies :restart, resources(:service => "apache2")
end


begin
  Chef::Log.info "Checking configured subversion repos for #{node['fqdn']}"
  repo_access_rules_per_host = data_bag_item("subversion", "repos")
  repo_access_rules = repo_access_rules_per_host[node['fqdn']]
rescue Net::HTTPServerException => e
  repo_access_rules = nil
  Chef::Log.warn "Data bag 'subversion' with item 'repos' is missing, not configuring any repositories..."
end

# only do something if repo_access_rules are configured (and only additive)
if repo_access_rules
  Chef::Log.info "configuring subversion repo_access_rules on #{node['fqdn']}: #{repo_access_rules.inspect}"

  # collect all mentioned users
  repo_users = []
  repo_access_rules.each do |rule|
    repo_users += (rule["rw"] || []) 
    repo_users += (rule["r"] || [])
  end

  repos = repo_access_rules.map{ |rule| rule['name'].gsub(/:.*/, '') }.uniq
  Chef::Log.info "creating subversion repos on #{node['fqdn']}: #{repos.inspect}"
  
  # create repos
  repos.each do |repo_name|
    execute "svnadmin create repo #{repo_name}" do
      command "svnadmin create #{repo_base}/#{repo_name}"
      creates "#{repo_base}/#{repo_name}"
      user node['apache']['user']
      group node['apache']['user']
      environment ({'HOME' => '/var/www'})
    end
  end

  # get repo users as configured in subversion/users data bag
  begin
    users_per_host = Chef::EncryptedDataBagItem.load("subversion", "users")
    users = users_per_host[node['fqdn']]
  rescue Net::HTTPServerException => e
    raise "required 'users' item not found in databag 'subversion'"
  end
  
  # make sure users are added to htpasswd
  repo_users.uniq.each do |username|
    unless username == "*"
      user = users.find {|u| u["name"] == username}
      raise "user #{username} does not exist" unless user
      
      execute "adding #{username} to #{svn_base}/htpasswd" do
        command "htpasswd -sb #{svn_base}/htpasswd #{user['name']} #{user['password']}"
      end
    end
  end
else
  Chef::Log.info "no subversion repo_access_rules configured for #{node['fqdn']}"
end

template "#{svn_base}/access.conf" do
  source "access.conf.erb"
  variables(
    :access_rules => repo_access_rules || []
  )
  owner "root"
  group "root"
  mode "0644"
end




 