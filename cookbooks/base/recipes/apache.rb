#
# Cookbook Name:: base
# Recipe:: apache
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "apache2" do
    action :install
end

service "apache2" do
    action[:enable,:start]
end
