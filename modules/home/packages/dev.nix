{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # api debugging
    hoppscotch

    # container tooling
    podman
    podman-desktop
    kubectl
    k9s
    kubernetes-helm

    # database tooling
    postgres
    antares

    # gRPC tooling
    buf
    protobuf_28 # legacy -> use buf
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
