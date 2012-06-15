#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "iptables"

package "apache2" do
    action :install
end

execute "a2dissite" do
    command "a2dissite 000-default"
    action :run
end

template "/etc/apache2/ports.conf" do
    source "ports.conf.erb"
    owner "root"
    group "root" 
    mode "0600"
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

node['apache']['default_sites'].each do |site|
    template "/etc/apache2/sites-available/#{site}" do
        source "sites/#{site}.erb"
    end
    execute "a2ensite" do
        command "a2ensite #{site}"
    end
end

users = search(:users, 'groups:www-data')
users.each do |u|
    group "www-data" do
        members u.id
        append true
        action :modify
    end
end

service "apache2" do
    :restart
end

iptables_rule "port_http"
