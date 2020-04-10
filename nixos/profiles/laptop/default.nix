{ config, pkgs, ... }:
{
  imports = [
    ./../..
    ./../../../vendor/nixos-hardware/common/pc/laptop
    ./../../boards.nix
    ./../../graphical.nix
    ./../../rtl-sdr.nix
    ./../../syncthing.nix
  ];

  hardware.bluetooth.extraConfig = ''
    [General]
    Enable=Source,Sink,Media,Socket
  '';

  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.tcp.anonymousClients.allowedIpRanges = [ "127.0.0.1" ];
  hardware.pulseaudio.tcp.enable = true;

  hardware.steam-hardware.enable = true;

  home-manager.users.${config.resources.username} = import ../../../home/profiles/laptop;

  networking.dhcpcd.enable = false;

  networking.hosts = {
    "127.0.0.1" = [ "thethings.localhost" ];
  };
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "8.8.8.8" "8.8.4.4" ];
  networking.useNetworkd = true;
  networking.useDHCP = false;

  networking.mullvad.enable = true;

  networking.wireless.iwd.enable = true;

  programs.adb.enable = true;

  services.printing.enable = true;
  services.resolved.enable = true;

  systemd.network.enable = true;
  systemd.network.networks."10-physical".dhcpConfig.Anonymize = true;
  systemd.network.networks."10-physical".dhcpConfig.RouteTable = 2;
  systemd.network.networks."10-physical".dhcpConfig.UseHostname = false;
  systemd.network.networks."10-physical".dhcpConfig.UseNTP = false;
  systemd.network.networks."10-physical".linkConfig.RequiredForOnline = false;
  systemd.network.networks."10-physical".matchConfig.Name = "en* eth* wl*";
  systemd.network.networks."10-physical".networkConfig.DHCP = "yes";
  systemd.network.networks."10-physical".networkConfig.IPv6AcceptRA = true;
  systemd.network.networks."10-physical".extraConfig = ''
    [RoutingPolicyRule]
    FirewallMark=2
    Table=2
  '';

  sound.enable = true;
  sound.mediaKeys.enable = true;

  systemd.services.audio-off.description = "Mute audio before suspend";
  systemd.services.audio-off.enable = true;
  systemd.services.audio-off.serviceConfig.ExecStart = "${pkgs.pamixer}/bin/pamixer --mute";
  systemd.services.audio-off.serviceConfig.RemainAfterExit = true;
  systemd.services.audio-off.serviceConfig.Type = "oneshot";
  systemd.services.audio-off.serviceConfig.User = "${config.resources.username}";
  systemd.services.audio-off.wantedBy = [ "sleep.target" ];

  users.users.${config.resources.username}.extraGroups = [
    "adbusers"
  ];
}
