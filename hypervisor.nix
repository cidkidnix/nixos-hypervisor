{ config, lib, pkgs, ... }:

with lib;

let
   cfg = config.services.nixos-hypervisor;
in

{
  meta.maintainers = with lib.maintainers; [ cidkidnix ];
  
  options = {
    services.nixos-hypervisor = {
	enable = mkOption {
	  type = types.bool;
          default = false;
          description = ''
		module for nixos-hypervisor
	  '';
        };
     
     patches = {
	amd = mkOption {
	  type = types.bool;
          default = false;
          description = ''
		enable RX580 patch for reset
	  '';
	};
	
	acs = mkOption {
	  type = types.bool;
          default = false;
          description = ''
		acs override patch
	  '';
	};
     };

     vmmanager = {
	win10 = mkOption {
	  type = types.bool;
          default = false;
         };
      };

  };


	config = mkMerge [ 
	   mkIf cfg.enable {

		(mkIf cfg.vmmanager.win10.enable {
			systemd.services.vmmanager = {
				after = [ "multi-user.target" ];
				wantedBy = [ "multi-user.target" ];
				serviceConfig = {
					Type = "simple";
					ExecStart = ''
						${pkgs.bash}/bin/bash ${vmmanager}
					'';
				};
				path = [ pkgs.bash pkgs.libvirt pkgs.pciutils ];
			};
		})
		
		(mkIf cfg.patches.amd.enable {
			boot.kernelPatches = [
				{
					name = "acso";
					patch = ./patches/0006-add-acs-overrides_iommu.patch;
				}
			];
		})
		
		(mkIf cfg.patches.acs.enable {
			boot.kernelPatches = [
				{
         			       name = "no-bus-reset";
               			       patch = ./patches/0005-prevent-bus-reset-polaris10.patch;
        			}
     			];
		})
	}
];
