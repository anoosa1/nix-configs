{
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./configuration.nix
    ./users.nix
  ];
}
