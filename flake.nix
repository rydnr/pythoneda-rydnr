{
  description = "Rydnr interactions with PythonEDA domains";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    poetry2nix = {
      url = "github:nix-community/poetry2nix/v1.28.0";
      inputs.nixpkgs.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda = {
      url = "github:pythoneda/base/0.0.1a7";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.poetry2nix.follows = "poetry2nix";
    };
    pythoneda-git-repositories = {
      url = "github:pythoneda/git-repositories/0.0.1a4";
      inputs.pythoneda.follows = "pythoneda";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.poetry2nix.follows = "poetry2nix";
    };
    pythoneda-shared-nix = {
      url = "github:pythoneda-shared/nix/0.0.1a4";
      inputs.pythoneda.follows = "pythoneda";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.poetry2nix.follows = "poetry2nix";
    };
    pythoneda-python-packages = {
      url = "github:pythoneda/python-packages/0.0.1a3";
      inputs.pythoneda.follows = "pythoneda";
      inputs.pythoneda-git-repositories.follows = "pythoneda-git-repositories";
      inputs.pythoneda-shared-nix.follows = "pythoneda-shared-nix";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.poetry2nix.follows = "poetry2nix";
    };
    pythoneda-nix-flakes = {
      url = "github:pythoneda/nix-flakes/0.0.1a2";
      inputs.pythoneda.follows = "pythoneda";
      inputs.pythoneda-git-repositories.follows = "pythoneda-git-repositories";
      inputs.pythoneda-shared-nix.follows = "pythoneda-shared-nix";
      inputs.pythoneda-python-packages.follows = "pythoneda-python-packages";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.poetry2nix.follows = "poetry2nix";
    };
    pythoneda-infrastructure-base = {
      url = "github:pythoneda-infrastructure/base/0.0.1a5";
      inputs.pythoneda.follows = "pythoneda";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.poetry2nix.follows = "poetry2nix";
    };
    pythoneda-application-base = {
      url = "github:pythoneda-application/base/0.0.1a5";
      inputs.pythoneda.follows = "pythoneda";
      inputs.pythoneda-infrastructure-base.follows =
        "pythoneda-infrastructure-base";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.poetry2nix.follows = "poetry2nix";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        python = pkgs.python3;
        pythonPackages = python.pkgs;
        description = "Rydnr interactions with PythonEDA domains";
        license = pkgs.lib.licenses.gpl3;
        homepage = "https://github.com/rydnr/pythoneda-rydnr";
        maintainers = with pkgs.lib.maintainers; [ ];
      in rec {
        packages = {
          pythoneda-rydnr = pythonPackages.buildPythonPackage rec {
            pname = "pythoneda-rydnr";
            version = "0.0.1a2";
            src = ./.;
            format = "pyproject";

            nativeBuildInputs = [ pkgs.poetry ];

            propagatedBuildInputs = with pythonPackages; [
              pythoneda.packages.${system}.pythoneda
              pythoneda-git-repositories.packages.${system}.pythoneda-git-repositories
              pythoneda-python-packages.packages.${system}.pythoneda-python-packages
              pythoneda-shared-nix.packages.${system}.pythoneda-shared-nix
              pythoneda-nix-flakes.packages.${system}.pythoneda-nix-flakes
              pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base
              pythoneda-application-base.packages.${system}.pythoneda-application-base
            ];

            checkInputs = with pythonPackages; [ pytest ];

            pythonImportsCheck = [ ];

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
          default = packages.pythoneda-rydnr;
          meta = with lib; {
            inherit description license homepage maintainers;
          };
        };
        defaultPackage = packages.default;
        devShell = pkgs.mkShell {
          buildInputs = with pkgs.python3Packages; [ packages.default ];
        };
        shell = flake-utils.lib.mkShell {
          packages = system: [ self.packages.${system}.default ];
        };
      });
}
