{
  services.xserver = {
    enable = true;
    layout = "us";

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
    };

    displayManager = {
      defaultSession = "none+xmonad";

      lightdm = {
        enable = true;
        greeters.mini = {
          enable = true;
          user = "chen";
          extraConfig = ''
            [greeter]
            show-password-label = false
            password-alignment = left
            [greeter-theme]
            password-character = 0
            background-image = ""/
            background-color = "#2E3440"
            window-color = "#4C566A"
            border-color = "#4C566A"
            text-color = "#5E81AC"
            error-color = "#BF616A"
          '';
        };
      };
    };
  };
}
