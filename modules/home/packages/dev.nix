{pkgs, ...}: {
  home.packages = with pkgs; [
    # api debugging
    hoppscotch

    # container tooling
    podman
    podman-desktop
    kubectl
    k9s
    kubernetes-helm
    linkerd
    talosctl
    act

    # database tooling
    postgresql
    antares
    dbeaver-bin

    # gRPC tooling
    buf
    protobuf # legacy -> use buf
    protoc-gen-go # legacy -> use buf
    protoc-gen-go-grpc # legacy -> use buf

    # IaC tooling
    pulumi
    pulumiPackages.pulumi-go
    opentofu
    awscli2
    ssm-session-manager-plugin
    google-cloud-sdk
    aws-nuke

    # language
    harper
  ];
}
