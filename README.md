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

For the `subversion::server` recipe the subversion users, repositories and permissions are managed in the `subversion` databag.

Within this data bag there is the `repos` item which describes the repositories and access rights per host (as identified by `node['fqdn']`).

Example: `knife data bag show subversion repos`
```
{
  "id": "repos",
  "your.hostname.fqdn": [
    {
      "name": "repo1:/", 
      "rw": ["hans", "peter"],
      "r": ["karl"]
    },
    {
      "name": "repo2:/some/path/within/repo", 
      "rw": ["karl", "ulli"]
    }
  ]
}
```

The `users` item is an encrypted data bag item which contains the users and their subversion passwords per host. 

Example: `knife data bag show subversion users --secret=t0pS3cR3t`:
```
{
  "id": "users",
  "your.hostname.fqdn": [
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
    }
  ]
}
```

In order to show, create or edit the encrypted data bag you need to pass the `--secret` or `--secret-file` parameter. If you are working with Chef Solo, you can install the [knife-solo_data_bag](https://github.com/thbishop/knife-solo_data_bag) gem and use the `knife *solo* data bag ...` commands.  


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
