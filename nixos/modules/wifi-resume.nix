{ config, pkgs, lib, ... }:

{
  # Define the custom systemd service
  systemd.services.wifi-resume = {
    description = "Reconnect Wi-Fi interface after resuming system";
    after = [ "post-resumme.target" ];
    wantedBy = [ "post-resume.target" ];
    script = ''
      ${pkgs.kmod}/bin/modprobe -r mt7921e
      ${pkgs.kmod}/bin/modprobe mt7921e
    '';
    serviceConfig.Type = "oneshot";
  };
}
