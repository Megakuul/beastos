# BeastOS

Personalized and enhanced fork of [Frost-Phoenix/nixos-config](https://github.com/Frost-Phoenix/nixos-config). 

## 📚 Layout

-   [flake.nix](flake.nix) base of the configuration
-   [configs](configs) ⚙️ non-nix configurations
    - [nvim](configs/nvim) 💻 Neovim configuration (using lazy.nvim)
-   [hosts](hosts) 🌳 per-host configurations that contain machine specific configurations
    - [desktop](hosts/desktop/) 🖥️ Desktop specific configuration
    - [laptop](hosts/laptop/) 💻 Laptop specific configuration
    - [vm](hosts/vm/) 🗄️ VM specific configuration
-   [modules](modules) 🍱 modularized NixOS configurations
    -   [core](modules/core/) ⚙️ Core NixOS configuration
    -   [homes](modules/home/) 🏠 my [Home-Manager](https://github.com/nix-community/home-manager) config
-   [pkgs](flake/pkgs) 📦 Packages Build from source
-   [wallpapers](wallpapers/) 🌄 wallpapers collection

# 🚀 Installation 

> [!CAUTION]
> Applying custom configurations, especially those related to your operating system, can have unexpected consequences and may interfere with your system's normal behavior. While I have tested these configurations on my own setup, there is no guarantee that they will work flawlessly for you.
> **I am not responsible for any issues that may arise from using this configuration.**

> [!NOTE]
> It is highly recommended to review the configuration contents and make necessary modifications to customize it to your needs before attempting the installation.

#### 1. **Install NixOS**

First install nixos using any [graphical ISO image](https://nixos.org/download.html#nixos-iso). 
> [!NOTE]
> Only been tested using the Gnome graphical installer and choosing the ```No desktop``` option durring instalation.

#### 2. **Clone the repo**

```bash
nix-shell -p git
git clone https://github.com/Frost-Phoenix/nixos-config
cd nixos-config
```
#### 3. **Install script**
> [!CAUTION]
> For some computers, the default rebuild command might get stuck due to CPU cores running out of RAM. To fix that modify the install script line: ```sudo nixos-rebuild switch --flake .#${HOST}``` to ```sudo nixos-rebuild switch --cores <less than your max number of cores> --flake .#${HOST}```

> [!TIP]
> As it is better to know what a script does before running it, you are advised to read it or at least see the [Install script walkthrough](#Install-script-walkthrough) section before execution.
   
Execute and follow the installation script :
```bash
./install.sh
```

Move the configuration where you want it (e.g. `/etc/nixos`):
```bash
rm -rf /etc/nixos/*
mv . /etc/nixos
```
  
#### 4. **Reboot**

After rebooting, the config should be applied, you'll be greeted by hyprlock prompting for your password.

#### 5. **Manual config**

Even though I use home manager, there is still a little bit of manual configuration to do:
- Set Aseprite theme (they are in the folder `./nixos-config/modules/home/aseprite/themes`).
- Configure the browser (for now, all browser configuration is done manually).
- Change the git account information in `./modules/home/git.nix`
```nix
programs.git = {
   ...
   userName = "Frost-Phoenix";
   userEmail = "67cyril6767@gmail.com";
   ...
};
```

## Install script walkthrough

A brief walkthrough of what the install script does.

#### 1. **Get username**

You will receive a prompt to enter your username, with a confirmation check.

#### 2. **Set username**

The script will replace all occurancies of the default usename ```CURRENT_USERNAME``` by the given one stored in ```$username```

#### 3. Create basic directories

The following directories will be created:
- ```~/Music```
- ```~/Documents```
- ```~/Pictures/wallpapers/others```

#### 4. Copy the wallpapers

Then the wallpapers will be copied into ```~/Pictures/wallpapers/others``` which is the folder in which the ```wallpaper-picker.sh``` script will be looking for them.

#### 5. Get the hardware configuration

It will also automatically copy the hardware configuration from ```/etc/nixos/hardware-configuration.nix``` to ```./hosts/${host}/hardware-configuration.nix``` so that the hardware configuration used is yours and not the default one.

#### 6. Choose a host (desktop / laptop)

Now you will need to choose the host you want. It depend on whether you are using a desktop or laptop (or a VM altho it can be really buggy).

#### 7. Choose whether to install aseprite or not

To reduce installation time, you can choose to skip installing Aseprite. The installation process for Aseprite is time-intensive as it requires compiling over 1100 C++ files from source.

#### 8. Build the system

Lastly, it will build the system, which includes both the flake config and home-manager config.

# 👥 Credits

Thanks to Frost-Phoenix, the original creator of this massive beast [Frost-Phoenix/nixos-config](https://github.com/Frost-Phoenix/nixos-config).
