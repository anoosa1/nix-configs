{
  lib,
  ...
}:
{
  options.anoosa = {
    domain = lib.mkOption {
      type = lib.types.str;
      default = "asherif.xyz";
      description = "Domain name for services";
      example = "example.org";
    };
  };

  imports = [
    ./soft-serve.nix
  ];
}

