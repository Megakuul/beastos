{pkgs, ...}: {
  home.packages = with pkgs; [
    # editors
    vscodium

    # api debugging
    hoppscotch

    # remotemanagement
    teleport_18

    # container tooling
    podman
    podman-desktop
    kubectl
    k9s
    kubernetes-helm
    linkerd
    talosctl

    # database tooling
    postgresql
    antares

    # gRPC tooling
    buf
    protobuf # legacy -> use buf
    protoc-gen-go # legacy -> use buf
    protoc-gen-go-grpc # legacy -> use buf

    # x509 and other crypto container tooling
    step-cli
    openssl

    # IaC tooling
    pulumi
    pulumiPackages.pulumi-go
    opentofu
    awscli2
    google-cloud-sdk
  ];
}
