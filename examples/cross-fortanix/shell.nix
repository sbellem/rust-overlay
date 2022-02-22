# See docs/cross_compilation.md for details.
#(import <nixpkgs> {
#(import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/93883402a445ad467320925a0a5dbe43a949f25b.tar.gz") {
#(import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/a7ecde854aee5c4c7cd6177f54a99d2c1ff28a31.tar.gz") {
(import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/9a3cfff2f9035ca0bd54ff13b608c4492eca6be3.tar.gz") {
  #crossSystem = (import <nixpkgs/lib>).systems.examples.gnu64 // {
  #crossSystem = {
  #  config = "x86_64-linux";
  #};
  crossSystem = {
  #crossSystem = (import <nixpkgs/lib>).systems.examples.gnu64 // {
    config = "x86_64-linux";
    #config = "x86_64-fortanix-unknown-sgx";
    #config = "x86_64-unknown-linux-gnu";
    rustc.config = "x86_64-fortanix-unknown-sgx";
    rustc.platform = builtins.fromJSON (builtins.readFile ./fortanix-target-spec.json);
  };
  overlays = [ (import ../..) ];
}).callPackage (
#{ mkShell, openssl, pkg-config, rust-bin }:
#{ mkShell, clang_11, openssl, pkg-config, rust-bin }:
#{ mkShell, clang_11, llvmPackages_11.libclang, openssl, pkg-config, rust-bin }:
{ mkShell, clang_11, gcc, gcc_multi, llvmPackages_11, openssl, pkg-config, rust-bin }:
mkShell {
  nativeBuildInputs = [
    pkg-config
    #clang_11
    #llvmPackages_11.libclang.lib
    #rust-bin.nightly."2021-12-05".default
    #openssl
    #rust-bin.nightly."2021-11-04".default
    (rust-bin.nightly."2021-11-04".default.override {
      #extensions = [ "rust-src" "rustfmt" "rust-std" ];
      #extensions = [ "rustfmt" "rust-std" ];
      targets = [ "x86_64-fortanix-unknown-sgx" ];
    })
  ];

  buildInputs = [
    clang_11
    gcc
    gcc_multi
    llvmPackages_11.libclang.lib
    openssl
  ];
  #depsBuildBuild = [ clang_11 gcc llvmPackages_11.libclang.lib ];
  #depsBuildBuild = [ wasmtime ];

  LIBCLANG_PATH = "${llvmPackages_11.libclang.lib}/lib";

  # This is optional for wasm32-like targets, since rustc will automatically use
  # the bundled `lld` for linking.
  # CARGO_TARGET_WASM32_WASI_LINKER = "${stdenv.cc.targetPrefix}cc";
  #CARGO_TARGET_WASM32_WASI_RUNNER = "wasmtime";

  RUST_BACKTRACE = 1;

  #CFLAGS_x86_64_fortanix_unknown_sgx = "-isystem/usr/include/x86_64-linux-gnu -mlvi-hardening -mllvm -x86-experimental-lvi-inline-asm-hardening";
  #CC_x86_64_fortanix_unknown_sgx = "clang-11";
  #CARGO_TARGET_X86_64_FORTANIX_UNKNOWN_SGX_RUNNER = "ftxsgx-runner-cargo";
}) {}
