#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "libapache2-mod-php5" do
    action :install
end
package "php-gettext" do
    action :install
end
package "php-pear" do
    action :install
end
package "php5" do
    action :install
end
package "php5-cli" do
    action :install
end
package "php5-common" do
    action :install
end
package "php5-curl" do
    action :install
end
package "php5-dev" do
    action :install
end
package "php5-gd" do
    action :install
end
package "php5-imagick" do
    action :install
end
package "php5-imap" do
    action :install
end
package "php5-mysql" do
    action :install
end
package "php5-xmlrpc" do
    action :install
end
package "php5-memcache" do
    action :install
end
package "php-apc" do
    action :install
end
template "/etc/php5/apache2/php.ini" do
    source "mods/php5.ini.erb"
    notifies :restart, "service[apache2]", :immediately
end
