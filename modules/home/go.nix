{ pkgs, ... }:
{
  home.packages = with pkgs; [ 
    go 
    gopls 
    gofumpt 
    golangci-lint
    air
    protoc-gen-go
    protoc-gen-go-grpc
  ];
}
