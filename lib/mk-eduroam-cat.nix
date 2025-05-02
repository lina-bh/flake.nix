{
  fetchurl,
  stdenvNoCC,
  python3,
  profile,
  university,
  hash,
}:
let
  pname = "eduroam-linux-${university}";
in
stdenvNoCC.mkDerivation {
  inherit pname;
  version = hash;
  src = fetchurl {
    inherit hash;
    url = "https://cat.eduroam.org/user/API.php?action=downloadInstaller&profile=${toString profile}&device=linux";
  };

  buildInputs = [
    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        pyopenssl
        tkinter
        dbus-python
      ]
    ))
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m 0755 $src $out/bin/${pname}.py
  '';

  meta.mainProgram = "${pname}.py";
}
