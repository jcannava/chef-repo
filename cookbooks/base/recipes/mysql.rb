#
# Cookbook Name:: base
# Recipe:: mysql
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "mysql-server" do
    action :install
end

service "mysql" do
    action[:enable,:start]
end
