{ config, pkgs, lib, ... }:

{
  # Define the custom systemd service
  systemd.services.wifi-resume = {
    description = "Restart Wi-Fi after hibernation";
    after = [ "hibernate.target" ];
    wantedBy = [ "hibernate.target" ];
    script = ''
      ${pkgs.kmod}/bin/modprobe -r mt7921e
      ${pkgs.kmod}/bin/modprobe mt7921e
    '';
  };
}
