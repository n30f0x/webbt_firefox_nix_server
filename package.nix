{
  pkgs,
  lib,
  stdenv,
  craneLib, 
}:
  let
    pname' = "webbt_firefox_nix_server";
    version' = "0.6.0";
    hash' = "sha256-IMACSEzFOV5P8Iy5uoNausKbkTFnxXv40WlztF4ycWk=";
    target = pkgs.rust.toRustTargetSpec pkgs.stdenv.targetPlatform;
    # see https://github.com/nix-community/fenix/issues/95
    shoutTarget = builtins.replaceStrings [ "-" ] [ "_" ] (lib.toUpper target);
  in
  craneLib.buildPackage
{
        pname = pname';
        version = version';
        src = (pkgs.fetchFromGitHub {
           owner = "stevennyman";
           repo = "webbt";
           tag = version';
           hash = hash';
           fetchSubmodules = true;
        } + "/rust_server");

        nativeBuildInputs = with stdenv; [ cc ];

        "CARGO_TARGET_${shoutTarget}_LINKER" = "${pkgs.stdenv.cc.targetPrefix}cc";

        installPhase = ''
          mkdir -p $out/bin/
          cp target/release/BLEServer $out/bin/${pname'}
          ln -s $out/bin/${pname'} webbt-server
        '';
}
