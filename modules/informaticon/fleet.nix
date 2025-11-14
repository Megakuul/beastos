{...}: {
  services.orbit = {
    enable = true;
    fleetUrl = "https://fleetdm.informaticon.com";
    enrollSecretPath = "/tmp/fleet/enroll_secret";
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
