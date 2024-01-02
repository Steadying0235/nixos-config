{ config, pkgs, ... }:

{
  systemd.services.powertop = {
    description = "PowerTOP auto-tune";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
      RemainAfterExit = "yes";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
