{ config, pkgs, ... }:

{
nix = {
        autoOptimiseStore = true;
        maxJobs = 6;
	package = pkgs.nixUnstable;
	extraOptions = ''
		experimental-features = nix-command flakes
	'';
        gc = {
                automatic = true;
                dates = "12:00";
                options = "--delete-older-than 7d";
        };
  };
}
