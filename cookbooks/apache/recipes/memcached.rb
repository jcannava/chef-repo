#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "memcached" do
    action :install
end

service "memcached" do
    service_name "memcached"
    restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
    action :enable
end

template "/etc/memached.conf" do
    source "memcached.conf.erb"
    notifies :restart, "service[memcached]"
end
    
