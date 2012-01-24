#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "apache2" do
    action :install
end

execute "a2dissite" do
    command "a2dissite 000-default"
    action :run
end

service "apache2" do
    service_name "apache2"
    restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
    reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
    action :enable
end

node['apache']['default_modules'].each do |mod|
    recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
    include_recipe "apache::#{recipe_name}"
end
