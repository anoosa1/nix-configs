self: super: {
  # Override the kernelPackages set, patching the broadcom_sta module.
  kernelPackages = super.kernelPackages.override {
    broadcom_sta = super.kernelPackages.broadcom_sta.overrideAttrs (oldAttrs: {
      # Append your local patch to the existing list of patches (if any).
      patches = (oldAttrs.patches or []) ++ [ ./379913.patch ];
    });
  };
}
