#
# Cookbook Name:: base
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "mlocate" do
 action :install
end

package "vim" do
 action :install
end

package "git-core" do
 action :install
end

package "python2.6" do
 action :install
end

package "ntp" do
    action :install
end

template "/etc/ntp.conf" do
    source "ntp.conf.erb"
    variables(:ntp_server => "time.nist.gov")
end

service "ntpd" do
    action[:enable,:start]
end

sysadmins_group = Array.new

search(:users, 'groups:sysadmins') do |u|
    sysadmins_group << u['id']
    home_dir = "/home/#{u['id']}"
    username = "#{u['id']}"

    ruby_block "reset group list" do
        block do
            Etc.endgrent
        end
        action :nothing
    end

    user u['id'] do
        uid u['uid']
        gid u['gid']
        shell u['shell']
        comment u['comment']
        supports :manage_home => true
        home home_dir
        notifies :create, "ruby_block[reset group list]", :immediately
    end

    directory "#{home_dir}/.ssh" do
         owner u['id']
         group u['gid'] || u['id']
    end

    template "#{home_dir}/.ssh/authorized_keys" do
        source "authorized_keys.erb"
        owner u['id']
        group u['gid'] || u['id']
        mode "0600"
        variables :ssh_keys => u['ssh-keys']
    end

    template "#{home_dir}/.vimrc" do
    	source "vimrc.erb"
        owner u['id']
        group u['gid'] || u['id']
    end

    template "#{home_dir}/.bash_profile" do
    	source "bash_profile.erb"
        owner u['id']
        group u['gid'] || u['id']
    end

    template "/etc/sudoers" do
        source "sudoers.erb"
        mode "0440"
    end

    execute "generate ssh keys #{username}." do
        not_if { File.exists?("#{home_dir}/.ssh/id_rsa") }
        user u['id']
        command "ssh-keygen -t rsa -q -f #{home_dir}/.ssh/id_rsa -P \"\""
    end
end

group "sysadmins" do
    gid 501
    members sysadmins_group
end
