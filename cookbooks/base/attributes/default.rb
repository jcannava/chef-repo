default[:base][:ssh_key_generated] = false
default[:tags][:rackspace] = true
default[:cloud][:local_ipv4] = attribute?('rackspace') ? network['interfaces']['eth1'] : network[:interfaces][:eth1][:addresses].find {|addr, addr_info| addr_info[:family] == "inet"}.first
