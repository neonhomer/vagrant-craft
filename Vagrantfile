# -*- mode: ruby -*-
# vi: set ft=ruby :

# Determine if we are running on windows
require 'rbconfig'
is_windows = (RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/)

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/xenial64"

  # Port is the phone-coded of the first 4 characters of the final URL
  config.vm.network "forwarded_port", guest: 80, host: 8888 # Temp 8888
  config.vm.network "private_network", type: "dhcp"

  # For windows use SMB else use NFS to sync files to guest host
  if is_windows
    config.vm.synced_folder ".", "/vagrant",
      type: "smb",
      owner: "www-data",
      group: "www-data",
      mount_options: [ "rw", "mfsymlinks" ]
  else
    config.vm.synced_folder ".", "/vagrant",
      nfs: true,
      mount_options: [ "rw", "tcp", "fsc", "actimeo=1" ]
  end

  # Set VirtualBox memory and allow symbolic links on Windows
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  # Run the shell commands
  config.vm.provision "shell", path: "bootstrap.sh"
end
