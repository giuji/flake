{ config, pkgs, lib, ... }:

let
  
  # emacs org stuff, took this from https://nixos.wiki/wiki/TexLive
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
  });

  # add this to your emacs init file
  # (setq org-latex-compiler "lualatex")
  # (setq org-preview-latex-default-process 'dvisvgm)
  
in
{

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


  environment.systemPackages = with pkgs; [
    emacs29-pgtk
    tex # see let binding
  ];
  
}
