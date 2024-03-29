# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib, inputs,... }:

{
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
      "https://jakestanger.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "jakestanger.cachix.org-1:VWJE7AWNe5/KOEvCQRxoE8UsI2Xs2nHULJ7TEjYm7mM="
    ];
  };
  fonts.fonts = with pkgs; [
    noto-fonts-cjk
    jetbrains-mono
    nerdfonts
  ];
  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };
  qt.platformTheme = "qt5ct";
  services.dbus.enable = true;
  # Use the systemd-boot EFI boot loader.
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  environment.loginShellInit = ''
    dbus-update-activation-environment --systemd --all
  '';

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Taipei";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  

  # Configure keymap in X11
  services.xserver.layout = "us";
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound = {
     enable = true;
     mediaKeys.enable = true;
  };

  hardware.pulseaudio.enable = false;
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };


  services.pipewire = {
       enable = true;
       alsa = {
         enable = true;
         support32Bit = true;
       };
       wireplumber.enable = true;
       pulse.enable = true;
       jack.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kyle = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      chromium
      neovim
      helix
      tree
     ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal
    wget
    helix
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

