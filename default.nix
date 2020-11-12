{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "solvers";
  buildInputs = with pkgs;
    [ python z3 yices boolector cvc4 time ];
}
