# manual: nixos-help
# manpage: man configuration.nix'

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];


  environment = {
    systemPackages = with pkgs; [
      chromium
      neovim
      htop
      neofetch
      alacritty
      git
      ghc
      lxqt.lxqt-themes
      haskellPackages.xmonad
      feh
      okular
      qbittorrent
      mpv
      spotify
      discord
      etcher
      openssh
      lxqt.qlipper
      xfce.xfwm4
      dmenu
    ];

    lxqt.excludePackages = with pkgs; [
      lxqt.lximage-qt
      lxqt.qps
      lxqt.lxqt-runner
      lxqt.obconf-qt
      openbox
    ];

    sessionVariables = rec {
	EDITOR = "nvim";
	TERMINAL = "alacritty";
    };


    etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
    formatted;
  };


  services = {

    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" ];
      desktopManager = {
        lxqt.enable = true;
      };

      displayManager = {
        sddm = {
	  enable = true;
	  theme = "maldives";
	  setupScript = 
	  ''
	    feh --bg-scale /home/fm/Pictures/001.jpg
	  '';

	};
	defaultSession = "lxqt";
      	autoLogin = {
   	  enable = true;
	  user = "fm";
        };
      };  

      layout = "se";
    };


    unclutter-xfixes = {
      enable = true;
      timeout = 3;
      extraOptions = ["noevents"];
     };

     clipmenu.enable = true;
  };


  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  networking.hostName = "herring";
  networking.networkmanager.enable = true;

  programs.nm-applet.enable = true;

  time.timeZone = "Europe/Stockholm";

  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.utf8";
    LC_IDENTIFICATION = "sv_SE.utf8";
    LC_MEASUREMENT = "sv_SE.utf8";
    LC_MONETARY = "sv_SE.utf8";
    LC_NAME = "sv_SE.utf8";
    LC_NUMERIC = "sv_SE.utf8";
    LC_PAPER = "sv_SE.utf8";
    LC_TELEPHONE = "sv_SE.utf8";
    LC_TIME = "sv_SE.utf8";
  };

  console.keyMap = "sv-latin1";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.fm = {
    isNormalUser = true;
    description = "fm";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
                "electron-12.2.3"
              ];
  };
	
  system.stateVersion = "22.05"; # Did you read the comment?
}
