Description
===========

Installs subversion for clients or sets up a server under Apache HTTPD.

Requirements
============

## Platforms:

* Debian/Ubuntu
* RHEL/CentOS
* Fedora
* Windows

## Cookbooks:

* apache2


Attributes
==========

See `attributes/default.rb` for default values. The attributes are
used in the server recipe.


* `node['subversion']['svn_dir']` - filesystem location of the
  base directory for svn (containing the `htaccess` and `access.conf` files).
* `node['subversion']['repo_base_dir']` - filesystem location of the
  base directory for the svn repositories to serve.
* `node['subversion']['server_name']` - server name used in the svn vhost.

The repositories and users are defined in databags as shown below.

Databags
========

The repositories and access rights are managed in a databag per host (i.e. identified by `node['hostname']`) in the `subversion` item.

Example: `$CHEF_REPO/databags/#{node['hostname']}/subversion.json`
```
{
  "id": "subversion",
  "repos": [
    {
      "name": "repo1", 
      "rw": ["hans", "peter"],
      "r": ["karl"]
    },
    {
      "name": "repo2", 
      "rw": ["karl", "ulli"]
    }]
}
```

For now the users and their credentials are defined in a global `users` databag in the `users` item, but should be replaced by another mechanism (or at least using encrypted databags) in the future.

Example: `$CHEF_REPO/databags/users/users.json`
```
{
  "id": "users",
  "users": [
    {
      "name": "hans", 
      "password": "123"
    },
    { 
      "name": "peter", 
      "password": "123"
    },
    {
      "name": "karl", 
      "password": "123"
    },
    {
      "name": "ulli", 
      "password": "123"
    }]
}
```

Recipes
=======

default
-------

Includes `recipe[subversion::client]`.

client
------

Installs `subversion` packages.

server
------

Sets up an SVN repository server with `recipe[apache2::mod_dav_svn]`.
This will use the `web_app` definition from the apache cookbook to
drop off the template, and uses the attributes for configuration.

Usage
=====

On nodes where `subversion` should be installed such as application
servers that will check out a repository, use `recipe[subversion]`. If
you would like a subversion server, use `recipe[subversion::server]`.

License and Author
==================

Author:: Adam Jacob <adam@opscode.com>
Author:: Joshua Timberman <joshua@opscode.com>
Author:: Daniel DeLeo <dan@kallistec.com>
Author:: Torben Knerr <mail@tknerr.de>

Copyright:: 2008-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
