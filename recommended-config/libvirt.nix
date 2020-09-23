{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" "pcie_acs_override=downstream,multifunction" "pcie_aspm=off" "video=efifb:off" ];
  boot.extraModprobeConfig = "options vfio-pci ids=10de:1c82,10de:0fb9,1002:aaf0,1002:67df";
  boot.kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];
  boot.blacklistedKernelModules = [ "nvidia" "nouveau" ];
  boot.kernelPatches = [
        {
                name = "acso";
		patch = ./patches/0006-add-acs-overrides_iommu.patch;
        }
	{
                name = "no-bus-reset";
                patch = ./patches/0005-prevent-bus-reset-polaris10.patch;
        }
   ];
  
  virtualisation.libvirtd = {
        enable = true;
        qemuVerbatimConfig = ''
                user = "jupiter"
        '';
  };
}
