{
  inputs,
  ...
}:
{
  ## sops
  sops = {
    defaultSopsFile = "${inputs.secrets}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      keyFile = "/home/anas/.local/etc/sops/age/keys.txt";
    };
  };
}
