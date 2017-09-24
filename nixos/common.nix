{ config, pkgs, lib, ... }:

with lib;

let
  keys = import ./keys.nix;
  secrets = import ./secrets.nix;
  unstable = import <nixpkgs-unstable> {};

  #hosts = import ./ho

  vars = import ./variables.nix { inherit pkgs; };

  rubyVersion = "2.4.0";
in
  rec {
    imports = [ 
      ./hardware-configuration.nix
      ./thinkpad.nix
      ./programs-base.nix
      ./programs-graphical.nix
      #./luks.nix
    ];

    programs.chromium.homepageLocation = "https://duckduckgo.com/?key=${secrets.duckduckgo.key}";
    boot = {
      initrd.luks.devices = [
        {
          name = "luksroot";
          device = "/dev/sda2";
          preLVM=true;
          allowDiscards=true;
        }
      ];

      loader = {
        grub.enable = false;
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      cleanTmpDir = true;
    };

    hardware = {
      pulseaudio = {
        enable = true;
        package = pkgs.pulseaudioFull;
      };

      opengl = {
        enable = true;
        driSupport32Bit = true;
      };
    };

    fonts = {
      enableFontDir = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        terminus_font
        dejavu_fonts
        font-awesome-ttf
        siji
        fira
        fira-mono
      ];
    };

    fileSystems = {
      "/".options = [ "noatime" "nodiratime" "discard" ];
      "/home".options = [ "noatime" "nodiratime" "discard" ];
      #"/mnt/torrent" = {
        #  device = "${pkgs.rclone}/bin/rclonefs#gspot:/var/torrent";
        #  fsType = "fuse";
        #  options = [ "config=/home/rvolosatovs/.config/rclone/rclone.conf" "allow-other" "default-permissions" "read-only" "max-read-ahead=16M" ];
        #  noCheck = true;
        #  };
      };

      networking = {
        hostName = "${vars.hostname}";
        #nameservers = [
          #""
          #];
          #wireguard.interfaces = {
            #wg0  = {
              #postSetup = [ "${pkgs.bash}/bin/bash -c 'printf \"nameserver ${dnsServer}\" | ${pkgs.openresolv}/bin/resolvconf -a tun.wlp4s0 -m 0 -x'" ];
              #postShutdown = [ "${pkgs.bash}/bin/bash -c '${pkgs.openresolv}/bin/resolvconf -d tun.wlp4s0'" ];

              #ips = [ "${vpnIP}/24" ];
              #privateKey = "${secrets.wireguard.client.privateKey}";
              ## TODO
              ##privateKeyFile = "/home/${vars.username}/.config/wireguard/privatekey";
              #peers = [
                #{
                  #allowedIPs = [ "0.0.0.0/0" "::/0" ];
                  #endpoint = "${secrets.servers.vpn.addr}:51820";
                  #publicKey = "${secrets.wireguard.server.publicKey}";
                  #presharedKey = "${secrets.wireguard.presharedKey}";
                  #}
                  #];
                  #};
                  #};
                };

                i18n = {
                  consoleFont = "Lat2-Terminus16";
                  consoleKeyMap = "us";
                  defaultLocale = "en_US.UTF-8";
                };

                time.timeZone = "Europe/Amsterdam";

                environment = {
                  sessionVariables = {
                    EMAIL="${vars.email}";
                    EDITOR="${vars.editor}";
                    VISUAL="${vars.editor}";
                    BROWSER="${vars.browser}";
                    PAGER="${vars.pager}";

                    QT_QPA_PLATFORMTHEME="gtk2";
                  };

                };

                security = {
                  sudo = {
                    enable = true;
                    wheelNeedsPassword = false;
                  };
                };

                services = {
                  gnome3 = {
                    gnome-keyring.enable = true;
                    seahorse.enable = true;
                  };
                  xserver = {
                    enable = true;
                    xkbModel = "thinkpad";
                    xkbVariant = "qwerty";
                    layout = "lv,ru";
                    xkbOptions = "grp:alt_space_toggle,terminate:ctrl_alt_bksp,eurosign:5,caps:escape";
                    xrandrHeads = [ "DP1" "eDP1" ];
                    resolutions = [ { x = 3840; y = 2160; } { x = 1920; y = 1080; } ];

                    exportConfiguration = true;

                    videoDrivers = [ "intel" ];

                    #    xautolock = {
                      #      enable = true;
                      #      locker = "${pkgs.slock}/bin/slock";
                      #    };

                      desktopManager = {
                      default = "none";
                      xterm.enable = false;
                    };

                    displayManager = {
                      lightdm = {
                        enable = true;
                        autoLogin = {
                          enable = true;
                          user = "${vars.username}";
                        };
                        greeters.gtk = {
                          theme.package = pkgs.zuki-themes;
                          theme.name = "Zukitre";
                        };
                      };
                      sessionCommands = ''
                        #eval `${pkgs.keychain}/bin/keychain --eval id_rsa ttn`
                        #eval `${pkgs.keychain}/bin/keychain --eval --agents gpg`
                        #eval `${pkgs.keychain}/bin/keychain --eval --agents ssh`

                        # Set GTK_PATH so that GTK+ can find the theme engines.
                        export GTK_PATH="${config.system.path}/lib/gtk-2.0:${config.system.path}/lib/gtk-3.0"

                        # Java
                        export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.aatext=true -Dsun.java2d.xrender=true'

                        ${config.hardware.pulseaudio.package}/bin/pactl upload-sample /usr/share/sounds/freedesktop/stereo/bell.oga x11-bell
                        ${config.hardware.pulseaudio.package}/bin/pactl load-module module-x11-bell sample=x11-bell display=$DISPLAY

                        ${pkgs.feh}/bin/feh  --bg-fill "$HOME/pictures/wp"
                        #${pkgs.stalonetray}/bin/stalonetray -c "''${XDG_CONFIG_HOME}/stalonetray/stalonetrayrc" &
                        ${pkgs.dunst}/bin/dunst &
                        ${pkgs.networkmanagerapplet}/bin/nm-applet &
                        ${pkgs.xorg.xset}/bin/xset s off -dpms
                        ${pkgs.xorg.xsetroot}/bin/xsetroot -cursor_name left_ptr
                        ${pkgs.wmname}/bin/wmname LG3D

                        ${pkgs.sudo}/bin/sudo ''${HOME}/.local/bin/fix-keycodes

                        ''${HOME}/.local/bin/turbo disable

                        # Screen Locking (time-based & on suspend)
                        ${pkgs.xautolock}/bin/xautolock -detectsleep -time 5 \
                        -locker "/home/${vars.username}/.local/bin/lock -s -p" \
                        -notify 10 -notifier "${pkgs.libnotify}/bin/notify-send -u critical -t 10000 -- 'Screen will be locked in 10 seconds'" &
                        ${pkgs.xss-lock}/bin/xss-lock -- /home/${vars.username}/.local/bin/lock -s -p &
                      '';
                    };
                    windowManager = {
                      default = "bspwm";
                      bspwm.enable = true;
                    };
                  };

                  redshift = {
                    enable = true;
                    latitude = "51.4";
                    longitude = "5.4";
                  };
                  ntp.enable = true;
                  upower.enable = true;
                  xbanish.enable = true;
                  fprintd.enable = true;
                  printing.enable = true;
                  thermald.enable = true;
                  openssh.enable = true;
                  openvpn =  import ./ovpn.nix { 
                    inherit lib;
                    confdir = "/home/rvolosatovs/.config/vpn"; 
                    addr = secrets.servers.vpn.addr; 
                    hostname = secrets.servers.vpn.hostname;
                  };
                  acpid.enable = true;
                  journald.extraConfig = ''
                      SystemMaxUse=1G
                      MaxRetentionSec=5day
                  '';
                  logind.extraConfig = ''
                      IdleAction=suspend
                      IdleActionSec=300
                  '';
                  tlp = {
                    enable = true;
                    extraConfig = ''
                        # No errors occured so far, so maybe it's not required...
                        ## For BTRFS
                        ## https://wiki.archlinux.org/index.php/TLP#Btrfs
                        #SATA_LINKPWR_ON_BAT=max_performance

                        # Battery health
                        START_CHARGE_THRESH_BAT0=75
                        STOP_CHARGE_THRESH_BAT0=90
                        START_CHARGE_THRESH_BAT1=75
                        STOP_CHARGE_THRESH_BAT1=90
                    '';
                  };
                  dnscrypt-proxy = {
                    enable = true;
                  };
                  #unbound = {
                    #enable = true;
                    #extraConfig = ''
                    #server:
                    #do-not-query-localhost: no
                    #forward-zone:
                    #name: "."
                    #forward-addr: 127.0.0.1@5353
                    #'';
                    #};
                    #udev.extraRules= ''
                    #KERNEL="ttyUSB[0-9]*", TAG+="udev-acl", TAG+="uaccess", OWNER="rvolosatovs"
                    #KERNEL="ttyACM[0-9]*", TAG+="udev-acl", TAG+="uaccess", OWNER="rvolosatovs"

                    #SUBSYSTEM!="usb_device", ACTION!="add", GOTO="avrisp_end"

                    ## Atmel Corp. JTAG ICE mkII
                    #ATTR{idVendor}=="03eb", ATTRS{idProduct}=="2103", MODE="660", GROUP="dialout"
                    ## Atmel Corp. AVRISP mkII
                    #ATTR{idVendor}=="03eb", ATTRS{idProduct}=="2104", MODE="660", GROUP="dialout"
                    ## Atmel Corp. Dragon
                    #ATTR{idVendor}=="03eb", ATTRS{idProduct}=="2107", MODE="660", GROUP="dialout"

                    #LABEL="avrisp_end"
                    #'';
                    };

                    virtualisation = {
                    docker.enable = true;
                    virtualbox.host.enable = true;
                    };

                    systemd = {
                    #mounts = [
                    #{
                    #enable = true;
                    #wantedBy = [ "multi-user.target" ];
                    #after = [ "network-online.target" ];
                    #wants = [ "network-online.target" ];
                    ##requires = [ "systemd-networkd.service" ];
                    #what = "${pkgs.rclone}/bin/rclonefs#${secrets.servers.torrent.hostname}:/var/torrent";
                    #where = "/mnt/torrent";
                    #type = "fuse";
                    #options="auto,config=/home/${vars.username}/.config/rclone/rclone.conf,allow-other,default-permissions,read-only,max-read-ahead=16M";
                    #mountConfig = {
                      #Environment = "SSH_AUTH_SOCK=/var/run/user/1000/gnupg/d.688bdxm4zjigcn1ip7rw474j/S.gpg-agent.ssh";
                      #TimeoutSec = "10";
                      #};
                      #}
                      #];

                      services = {
                        systemd-networkd-wait-online.enable = false;

                        audio-off = {
                          enable = true;
                          description = "Mute audio before suspend";
                          wantedBy = [ "sleep.target" ];
                          serviceConfig = {
                            Type = "oneshot";
                            User = "${vars.username}";
                            ExecStart = "${pkgs.pamixer}/bin/pamixer --mute";
                            RemainAfterExit = true;
                          };
                        };

                        godoc = {
                          enable = true;
                          wantedBy = [ "multi-user.target" ];
                          environment = {
                            "GOPATH" = "/home/${vars.username}";
                            };
                            serviceConfig = {
                            User = "${vars.username}";
                            ExecStart = "${pkgs.gotools}/bin/godoc -http=:6060";
                            };
                            };

                            openvpn-reconnect = {
                              enable = true;
                              description = "Restart OpenVPN after suspend";

                              wantedBy= [ "sleep.target" ];

                              serviceConfig = {
                                ExecStart="${pkgs.procps}/bin/pkill --signal SIGHUP --exact openvpn";
                              };
                            };
                          };
                          #user.services = {
                            #torrents = {
                              #wantedBy = [ "default.target" ];
                              #after = [ "ssh-agent.service" "gpg-agent-ssh.socket" ];
                              #wants = [ "ssh-agent.service" "gpg-agent-ssh.socket" ];
                              #environment = {
                                #"SSH_AUTH_SOCK" = "%t/gnupg/d.688bdxm4zjigcn1ip7rw474j/S.gpg-agent.ssh";
                                #"PATH" = "/var/run/current-system/bin";
                                #};
                                #serviceConfig = {
                                  #ExecStart = "${pkgs.rclone}/bin/rclone mount ${secrets.servers.torrent.hostname}:/var/torrent %h/mnt/torrent";
                                  #};
                                  #};
                                  #};
                                  };


                                  users = {
                                    defaultUserShell = pkgs.zsh;
                                    users = {
                                      rvolosatovs = {
                                        isNormalUser = true;
                                        initialPassword = "${vars.username}";
                                        home="/home/${vars.username}";
                                        description="Roman Volosatovs";
                                        createHome=true;
                                        extraGroups= [ "wheel" "input" "audio" "video" "networkmanager" "docker" "dialout" "tty" "uucp" "disk" "adm" "wireshark" ];
                                        openssh.authorizedKeys = {
                                          keys = [
                                            keys.publicKey
                                          ];
                                        };
                                      };

                                      peyvand = {
                                        isNormalUser = true;
                                        initialPassword = "peyvand";
                                        extraGroups= [ "input" "audio" "video" ];
                                      };
                                    };
                                  };

                                  system = {
                                    stateVersion = "17.03";
                                    autoUpgrade.enable = true;
                                  };
                                }
