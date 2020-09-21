{ config, pkgs, ... }:

let
  vm-manager-amd = ./win10-vm-manager.sh;
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./filesystem.nix
      ./libvirt.nix
      ./nix.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  services.openssh.extraConfig = ''
	Match Address 192.168.122.*
		PubkeyAuthentication yes
  '';
  networking.firewall.extraCommands = ''
	iptables -A INPUT -p tcp --dport 22 --source 192.168.122.0/24 -j ACCEPT
	iptables -A INPUT -p tcp --dport 22 -j DROP
	ip6tables -A INPUT -p tcp --dport 22 -j DROP
  '';
  
  systemd.services.vm1 = {
        after = [ "multi-user.target" ];
        wantedBy = [ "multi-user.target" ];
	serviceConfig = {
                Type = "simple";
                ExecStart = ''
                        ${pkgs.libvirt}/bin/virsh start win10-amd
                '';
		ExecStop = ''
			${pkgs.libvirt}/bin/virsh shutdown win10-amd
		'';
        };
  };

  systemd.services.vm-manager = {
	after = [ "multi-user.target" ];
	wantedBy = [ "multi-user.target" ];
	serviceConfig = {
		Type = "simple";
		ExecStart = ''
			${pkgs.bash}/bin/bash ${vm-manager-amd}
		'';
	};
	path = [ pkgs.bash pkgs.libvirt pkgs.pciutils ];
  };

  networking.hostName = "jupiter-virt"; # Define your hostname.
  networking.networkmanager.enable = true;

  boot.extraModprobeConfig = ''
	options zfs zfs_arc_max=16426880008
  '';

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Packages
  environment.systemPackages = with pkgs; [
    wget vim git
  ];
  
  users.users.jupiter = {
	isNormalUser = true;
	extraGroups = [ "wheel" "libvirtd" ];
  };

  # Don't touch this
  system.stateVersion = "20.09"; # Did you read the comment?

}
