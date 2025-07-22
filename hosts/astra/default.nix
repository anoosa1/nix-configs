{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./configuration.nix
    ./hardware-configuration.nix
    ./users.nix
  ];
}
