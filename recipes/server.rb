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

apache_module "authz_svn"

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


Chef::Log.info "Checking configured subversion repos for #{node['fqdn']}"
repos_per_host = data_bag_item("subversion", "repos")
repos = repos_per_host[node['fqdn']]

# only do something if repos are configured (and only additive)
if repos
  Chef::Log.info "configuring subversion repos on #{node['fqdn']}: #{repos.inspect}"

  # create repos
  repo_users = []
  repos.each do |repo|

    repo_name = repo['name']
    execute "svnadmin create repo #{repo_name}" do
      command "svnadmin create #{repo_base}/#{repo_name}"
      creates "#{repo_base}/#{repo_name}"
      user node['apache']['user']
      group node['apache']['user']
      environment ({'HOME' => '/var/www'})
    end

    repo_users += (repo["rw"] || []) 
    repo_users += (repo["r"] || [])
  end

  # make sure users are added to htpasswd
  users_per_host = data_bag_item("subversion", "users")
  users = users_per_host[node['fqdn']]
  
  repo_users.uniq.each do |username|
    user = users.find {|u| u["name"] == username}
    raise "user #{username} does not exist" unless user
    
    execute "adding #{username} to #{svn_base}/htpasswd" do
      command "htpasswd -sb #{svn_base}/htpasswd #{user['name']} #{user['password']}"
    end
  end
else
  Chef::Log.info "no subversion repos configured for #{node['fqdn']}"
end

template "#{svn_base}/access.conf" do
  source "access.conf.erb"
  variables(
    :repositories => repos
  )
  owner "root"
  group "root"
  mode "0644"
end




 