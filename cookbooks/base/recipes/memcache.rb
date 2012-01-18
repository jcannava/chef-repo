#
# Cookbook Name:: base
# Recipe:: mysql
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "memcached" do
    action :install
end

service "memcached" do
    action[:enable,:start]
end
