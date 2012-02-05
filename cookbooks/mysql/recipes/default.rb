#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "mysql-server" do
    action :install
end

template "/home/jcannava/.my.cnf" do
    source "db/my.cnf.erb"
end

service "mysql" do 
    service_name "mysql"
    restart_command "/usr/sbin/invoke-rc.d mysql restart && sleep 1"
    action :enable
end
