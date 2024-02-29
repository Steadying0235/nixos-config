{ config, pkgs, lib, ... }:

{
  # Define the custom systemd service
  systemd.services.wifi-resume = {
    description = "Restart Wi-Fi after hibernation";
    after = [ "hibernate.target" "suspend.target" "hybrid-sleep.target" ];
    wantedBy = [ "hibernate.target" "suspend.target" "hybrid-sleep.target" ];
    script = ''
      ${pkgs.kmod}/bin/modprobe -r iwlwifi
      ${pkgs.kmod}/bin/modprobe iwlwifi
    '';
  };
}
