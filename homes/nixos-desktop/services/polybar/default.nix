{ lib, pkgs, ... }:

let
  inherit (lib.attrsets) mapAttrs;
  nord = import ../../themes/nord.nix;
  icons = mapAttrs (n: v: "%{T3}${v}%{T-}") {
    memory = "";
    microchip = "";
    hard-drive = "";
    upload = "";
    download = "";
  };
in
{
  imports = [
    ./modules/ewmh.nix
  ];

  services.polybar = {
    enable = true;
    script = "polybar top &";
    package = pkgs.polybar.override {
      alsaSupport = true;
      mpdSupport = true;
      nlSupport = true;
      pulseSupport = true;
    };
    config = with nord; {
      "bar/top" = {
        height = "3%";
        width = "99.4%";
        offset-x = "0.3%";
        offset-y = "0.5%";
        radius = 0;
        dpi = 180; # HiDPI
        background = nord0;
        foreground = nord9;
        line-size = 5;
        padding = 2;
        cursor-click = "pointer";
        cursor-scroll = "ns-resize";
        enable-ipc = true;
        font-0 = "FiraCode Nerd Font:style=Regular:size=12;4";
        font-1 = "WenQuanYi Micro Hei:style=Regular:size=12;4";
        font-2 = "Font Awesome 6 Free Solid:style=Solid:size=12;4";
        module-margin = 1;
        modules-left = "ewmh";
        modules-center = "date";
        modules-right = "network temperature cpu filesystem memory pulseaudio";
        tray-position = "right";
        tray-maxsize = 32;
      };
      "global/wm" = {
        margin-bottom = "0.3%";
      };
      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        sink = "alsa_output.pci-0000_00_1f.3.hdmi-stereo"; # find using `pacmd list-sinks`, name field
        use-ui-max = false; # PA_VOLUME_NORM (100%)
        interval = 5;
        format-volume = "<ramp-volume> <label-volume>";
        label-volume = "%{F#8FBCBB}%percentage%%%{F-}";
        label-muted = "婢 %{F#8FBCBB}Muted%{F-}";
        ramp-volume-0 = "";
        ramp-volume-1 = "墳";
        ramp-volume-2 = "";

        click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
      };
      "module/date" = {
        type = "internal/date";
        internal = 1;
        date = "%b %d";
        time = "%H:%M";
        label = "%date% %{F#8FBCBB}%time%%{F-}";
      };
      "module/filesystem" = {
        type = "internal/fs";
        mount-0 = "/";
        interval = 10;
        fixed-values = true;
        format-mounted = "<label-mounted>";
        label-mounted = "${icons.hard-drive} %{F#8FBCBB}%percentage_used:2%%%{F-}";
      };
      "module/memory" = {
        type = "internal/memory";
        label = "${icons.memory} %{F#8FBCBB}%percentage_used:2%%%{F-}";
        format = "<label>";
      };
      "module/network" = {
        type = "internal/network";
        interface-type = "wired";
        interface = "enp86s0";
        format-connected = "<label-connected>";
        format-disconnected = "<label-disconnected>";
        format-packetloss = "<animation-packetloss> <label-connected>";
        label-connected = "${icons.upload} %{F#8FBCBB}%upspeed:9%%{F-} %{F#D8DEE9}/%{F-} ${icons.download} %{F#8FBCBB}%downspeed:9%%{F-}";
        label-disconnected = "";
      };
      "module/temperature" = {
        type = "internal/temperature";
        thermal-zone = 0;
        hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon3/temp1_input";
        format = "<label>";
        format-warn = "<label-warn>";
        label = " %{F#8FBCBB}%temperature-c%%{F-}";
        label-warn = " %{F#BF616A}%temperature-c%%{F-}";
      };
      "module/cpu" = {
        type = "internal/cpu";
        format = "${icons.microchip} <label>";
        label = "%{F#8FBCBB}%percentage-sum:2%%%{F-}";
      };
    };
  };
}
