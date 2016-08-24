# Copyright (C) 2014-2016 VMware, Inc.
require 'pathname'
vmware_module = Puppet::Module.find('vmware_lib', Puppet[:environment].to_s)
require File.join vmware_module.path, 'lib/puppet/property/vmware'

Puppet::Type.newtype(:nsx_application) do
  @doc = 'Manage NSX applications, these are used by fw rules'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'application name'
  end

  newproperty(:value, :array_matching => :all, :parent => Puppet::Property::VMware_Array, :sort => :true ) do
    desc 'application value, this is a string that can consist of port number(s) and ranges of ports'
    munge do |value|
      # since nsx treats these as strings, we are doing the same, this is needed to account for ranges
      value.to_s
    end
  end

  newproperty(:application_protocol) do
    desc 'application protocol, example TCP/UDP/ICMP/IGMP/FTP/etc ( way to many to list, refer to api guide for more available options'
    munge do |value|
      value.upcase
    end
  end

  newparam(:scope_type) do
    desc 'scope type, this can be either edge, datacenter, or global. if not specified, edge is the default'
    newvalues(:edge, :datacenter, :global_root, :global)
    defaultto(:edge)
    munge do |value|
      value = 'global_root' if value == 'global'
      value
    end
  end

  newparam(:scope_name) do
    desc 'scope name which will be used with scope_type to get/set applications'
  end

  newparam(:inclusive) do
    desc 'whether the resource value is inclusive'
    newvalues(:true, :false)
    defaultto(:true)
  end

  newparam(:preserve) do
    desc 'whether existing resource values are preserved'
    newvalues(:true, :false)
    defaultto(:false)
  end

  autorequire(:nsx_edge) do
    self[:name]
  end

end
