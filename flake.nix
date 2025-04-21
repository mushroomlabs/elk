{
  description = "Nuxt + Tauri dev shell for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          rustc
          cargo
          nodejs
          pkg-config
          glib
          openssl
          webkitgtk_4_1
          gtk3
          cargo-tauri
          libsoup_3
          gobject-introspection
          gdk-pixbuf
          cairo
          pango
          atk
        ];

        shellHook = ''
          export PKG_CONFIG_PATH=${pkgs.gtk3.dev}/lib/pkgconfig:${pkgs.webkitgtk.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
          export LD_LIBRARY_PATH=${pkgs.webkitgtk_6_0}/lib:$LD_LIBRARY_PATH
          echo "✅ ready for Tauri development"
        '';
      };
    }
  );
}
