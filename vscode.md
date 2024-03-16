Source: https://github.com/nix-community/NixOS-WSL/issues/294#issuecomment-1788405229

>Got vscode wsl remoting with NixOS to work. This is using the nix-ld approach
> 
> ### Version Info
> ```
> Windows 11 22H2
> WSL version 1.2.5.0
> vscode 1.83.1 (user setup)
> ms-vscode-remote.remote-wsl-0.81.8
> ```
> 
> ### Setup Instructions
> * download latest release from https://github.com/nix-community/NixOS-WSL/releases
> * import into wsl using `wsl --import nixos . .\nixos-wsl.tar.gz --version 2`
> * update channel `sudo nix-channel --update`
> * update nixos configs `sudo nano /etc/nixos/configuration.nix`
> 
> ```nix
>   wsl.extraBin = with pkgs; [
>     { src = "${coreutils}/bin/uname"; }
>     { src = "${coreutils}/bin/dirname"; }
>     { src = "${coreutils}/bin/readlink"; }
>   ];
> 
>   programs.nix-ld.enable = true;
> 
>   nix.settings.experimental-features = [ "nix-command" "flakes" ];
> 
>   environment.systemPackages = [
>     pkgs.wget
>   ];
> ```
> 
> * rebuild `sudo nixos-rebuild switch`
> * shutodwn wsl from powershell `wsl --shutdown` and confirm shutdown `wsl --list --running`
> * from nixos shell `mkdir ~/.vscode-server` & `curl https://raw.githubusercontent.com/sonowz/vscode-remote-wsl-nixos/master/server-env-setup -o ~/.vscode-server/server-env-setup`
> * from vscode attempt to connect via wsl.   Find NodeExecServer log message with how its being invoked
> 
> ```
> [2023-11-01 03:41:35.475] NodeExecServer run: C:\Windows\System32\wsl.exe -d nixos sh -c '"$VSCODE_WSL_EXT_LOCATION/scripts/wslServer.sh" f1b07bd25dfad64b0167beb15359ae573aecd2cc stable code-server .vscode-server --host=127.0.0.1 --port=0 --connection-token=2218860889-3195581200-2104464773-1251764395 --use-host-proxy --without-browser-env-var --disable-websocket-compression --accept-server-license-terms --telemetry-level=all'
> ```
> 
> * take log message, modify slightly, and run
> 
> ```powershell
> # note the changes to `wsl.exe -d nixos -e sh -l -c` and expanding the `$VSCODE_WSL_EXT_LOCATION`
> C:\Windows\System32\wsl.exe -d nixos -e sh -l -c '"/mnt/c/Users/Acelinkio/.vscode/extensions/ms-vscode-remote.remote-wsl-0.81.8/scripts/wslServer.sh" f1b07bd25dfad64b0167beb15359ae573aecd2cc stable code-server .vscode-server --host=127.0.0.1 --port=0 --connection-token=3823671665-1023682691-1766917102-882463176 --use-host-proxy --without-browser-env-var --disable-websocket-compression --accept-server-license-terms --telemetry-level=all'
> ```
> 
> * vscode wsl remoting now works....
