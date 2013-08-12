BOX_NAME    = ENV['BOX_NAME'] || "precise64"
BOX_URI     = ENV['BOX_URI']  || "http://files.vagrantup.com/precise64.box"
VF_BOX_NAME = ENV['BOX_NAME'] || "precise64_vmware_fusion"
VF_BOX_URI  = ENV['BOX_URI']  || "http://files.vagrantup.com/precise64_vmware_fusion.box"

Vagrant::Config.run do |config|
  # Setup virtual machine box. This VM configuration code is always executed.
  config.vm.box = BOX_NAME
  config.vm.box_url = BOX_URI
  config.vm.provision :shell, :path => "script/postinstall-boxgrinder.sh"
end

Vagrant::VERSION >= "1.1.0" and Vagrant.configure("2") do |config|
  # Configure for the virtualbox provider
  config.vm.provider :virtualbox do |vb, override|
    override.vm.box = BOX_NAME
    override.vm.box_url = BOX_URI
  end

  # Configure for the VMWare Fusion provider
  config.vm.provider :vmware_fusion do |f, override|
    override.vm.box = VF_BOX_NAME
    override.vm.box_url = VF_BOX_URI
    f.vmx["displayName"] = "boxgrinder"
  end
end
