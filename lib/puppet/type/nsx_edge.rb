# Copyright (C) 2014-2016 VMware, Inc.
require 'pathname'
vmware_module = Puppet::Module.find('vmware_lib', Puppet[:environment].to_s)
require File.join vmware_module.path, 'lib/puppet/property/vmware'

Puppet::Type.newtype(:nsx_edge) do
  @doc = 'Manage NSX edge.'

  newparam(:name, :namevar => true) do
    desc 'NSX manager hostname or ip address and NSX edge name seperated with : (i.e. manager:edge).'

    munge do |value|
      @resource[:manager], @resource[:edge_name] = value.split(':',2)
      value
    end
  end

  ensurable

  newparam(:manager, :parent => Puppet::Property::VMware) do
    desc 'NSX Manager, derived from namevar, do not specify.'
  end

  newparam(:edge_name, :parent => Puppet::Property::VMware) do
    desc 'NSX edge, derived from namevar, do not specify.'
  end

  newparam(:resource_pool_name, :parent => Puppet::Property::VMware) do
  end

  newparam(:datastore_name, :parent => Puppet::Property::VMware) do
  end

  newparam(:fqdn, :parent => Puppet::Property::VMware) do
  end

  newparam(:tenant, :parent => Puppet::Property::VMware) do
  end

  newparam(:appliance_size, :parent => Puppet::Property::VMware) do
    newvalues(:compact, :large, :XLarge)
    defaultto(:compact)
  end

  newparam(:appliance, :parent => Puppet::Property::VMware_Hash) do
  end

  newproperty(:vnics, :array_matching => :all, :parent => Puppet::Property::VMware_Array_Hash, :sort => :false ) do
  end

  newparam(:datacenter_name, :parent => Puppet::Property::VMware) do
  end

  newproperty(:enable_aesni, :parent => Puppet::Property::VMware) do
    newvalues(:true, :false)
  end

  newproperty(:enable_fips, :parent => Puppet::Property::VMware) do
    newvalues(:true, :false)
  end

  newproperty(:enable_tcp_loose, :parent => Puppet::Property::VMware) do
    newvalues(:true, :false)
  end

  newproperty(:vse_log_level, :parent => Puppet::Property::VMware) do
    newvalues('debug', 'info', 'emergency', 'alert', 'critical', 'error', 'warning', 'notice')
  end

  newproperty(:cli_settings, :parent => Puppet::Property::VMware_Hash) do
    desc 'cli settings ( remote access )'
    # override since nsx get does not display password
    def insync?(is)
      desire = @should.first.clone
      if desire.include?('password') and is.is_a? Hash
        is['password'] = desire['password']
      end
      super(is)
    end
  end

  newproperty(:upgrade) do
    newvalues(:true,:false)
    defaultto(:false)
  end

  autorequire(:transport) do
    self[:manager]
  end

  autorequire(:nsx_global_config) do
    self[:manager]
  end

end

