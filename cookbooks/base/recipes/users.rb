#
# Cookbook Name:: base
# Recipe:: users
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
sysadmins_group = Array.new

search(:users, 'groups:sysadmins') do |u|
    sysadmins_group << u['id']
    home_dir = "/home/#{u['id']}"

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

    template "/etc/sudoers" do
        source "sudoers.erb"
        mode "0440"
    end
end

group "sysadmins" do
    gid 501
    members sysadmins_group
end
