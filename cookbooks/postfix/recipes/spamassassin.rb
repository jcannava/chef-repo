#
# Author:: Joshua Timberman(<joshua@opscode.com>)
# Cookbook Name:: postfix
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
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
include_recipe "postfix::default"

package "spamassassin" do
  action :install
end

service "spamassassin" do
  action :enable
end

template "/etc/default/spamassassin" do
  source "spamassassin/default.spamassassin.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[spamassassin]", :immediately
end

spam_user = search(:db_users, "id:spamuser")
dbnode = search(:node, "role:dbsrv")
template "/etc/spamassassin/bayes.cf.erb" do
  source "spamassassin/bayes.cf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :db => spam_user[0][:db],
    :db_host => dbnode[0][:cloud][:local_ipv4],
    :spam_user => spam_user[0][:id],
    :spam_password => spam_user[0][:password]
  )
  notifies :restart, "service[spamassassin]", :immediately
end

template "/etc/spamassassin/csma.cf" do
  source "spamassassin/csma.cf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[spamassassin]", :immediately
end

template "/etc/spamassassin/filter.sh" do
  source "spamassassin/filter.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, "service[postfix]", :immediately
end

template "/etc/spamassassin/local.cf" do
  source "spamassassin/local.cf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, "service[spamassassin]", :immediately
end

template "/etc/spamassassin/nuke.pl" do
  source "spamassassin/nuke.pl.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, "service[spamassassin]", :immediately
end

template "/etc/spamassassin/pffilter.sh" do
  source "spamassassin/pffilter.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, "service[spamassassin]", :immediately
end

template "/etc/spamassassin/sideline.sh" do
  source "spamassassin/sideline.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, "service[spamassassin]", :immediately
end
