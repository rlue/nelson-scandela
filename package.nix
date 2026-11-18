# gemset.nix is generated from Gemfile.lock;
# regenerate it with `bundix` whenever the lockfile changes.
{ lib, stdenvNoCC, bundlerEnv, ruby, makeWrapper, version }:

let
  gems = bundlerEnv {
    name = "nelson-scandela-gems";
    inherit ruby;
    gemdir = ./.;
    groups = [ "default" ];
  };
in
stdenvNoCC.mkDerivation {
  pname = "nelson-scandela";
  inherit version;

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [ ./app ./config.ru ];
  };

  nativeBuildInputs = [ makeWrapper ];

  # app/app.rb runs `bundler/setup`, which the gem env's rackup wrapper
  # satisfies by pointing BUNDLE_GEMFILE at its own copy of the Gemfile
  # (minus the development group, which the env leaves out).
  # Further rackup flags (e.g. `--host 127.0.0.1 --port 9292`) pass through.
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/nelson-scandela
    cp -r app config.ru $out/share/nelson-scandela/
    makeWrapper ${gems}/bin/rackup $out/bin/nelson-scandela \
      --set BUNDLE_WITHOUT development \
      --add-flags "--server webrick --env production $out/share/nelson-scandela/config.ru"
    runHook postInstall
  '';

  passthru = { inherit gems; };

  meta = {
    description = "A barebones app for generating barcodes";
    homepage = "https://github.com/rlue/nelson-scandela";
    mainProgram = "nelson-scandela";
  };
}
