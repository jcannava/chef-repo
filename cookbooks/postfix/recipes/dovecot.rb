#
# Author:: Jason Cannavale (jason@cannavale.com)
# Cookbook Name:: postfix
# Recipe:: dovecot
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
include_recipe "mysql::client"

package "dovecot-common" do
  action :install
end

package "dovecot-imapd" do
  action :install
end

service "dovecot" do
  supports :status => true, :restart => true
  action [:enable, :start]
end

database = search(:node, "role:dbsrv")
mail_user = search(:db_users, "id:mail_admin")
template "/etc/dovecot/dovecot-sql.conf" do
  source "dovecot-sql.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
       :db_host => database[0][:cloud][:local_ipv4],
       :db_name => mail_user[0][:db],
       :mail_user => mail_user[0][:id],
       :mail_password => mail_user[0][:password]
  )
  notifies :restart, "service[dovecot]", :immediately
end

template "/etc/dovecot/dovecot.conf" do
  source "dovecot.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :ip_address => node[:cloud][:local_ipv4]
  )
  notifies :restart, "service[dovecot]", :immediately
end
