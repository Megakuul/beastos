{...}: {
  services.orbit = {
    enable = true;
    fleetUrl = "https://<todo>";
    # WARNING: use enrollSecretPath for secrets outside nix-store
    enrollSecret = "your-enroll-secret";
    debug = true;
    devMode = false;
    hostIdentifier = "uuid";
    enableScripts = false;
    fleetCertificate = "/etc/ssl/certs/ca-bundle.crt";
    fleetDesktopAlternativeBrowserHost = null;
    fleetManagedHostIdentityCertificate = false;
    endUserEmail = null;
    insecure = false;
  };
}
