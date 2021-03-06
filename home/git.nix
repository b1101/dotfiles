{ config, pkgs, ... }:

let
  gitignore = pkgs.writeText "gitignore" ''
    *.aux
    *.dvi
    *.ear
    *.jar
    *.log
    *.out
    *.pdf
    *.rar
    *.sql
    *.sqlite
    *.tar.gz
    *.test
    *.war
    *.zip
    *~
    ._*
    .ccls-cache/
    .direnv*
    .DS_Store
    .DS_Store?
    .envrc*
    .Spotlight-V100
    .Trashes
    .vscode
    ehthumbs.db
    shell.nix
    tags
    Thumbs.db
    token
  '';
in
  {
    home.packages = with pkgs; [
      git-lfs
    ] ++ (with gitAndTools; [
      delta
      git-extras
      hub
    ]);
    home.sessionVariables.GIT_EDITOR = config.resources.programs.editor.executable.path;

    programs.git.aliases.tree = "log --graph --pretty=format:'%C(auto)%h - %s [%an] (%C(blue)%ar)%C(auto)%d'";
    programs.git.aliases.xclean = "clean -xdf -e .envrc -e .direnv.* -e shell.nix -e default.nix -e vendor -e .vscode";

    programs.git.enable = true;
    programs.git.extraConfig."filter \"lfs\"".clean = "${pkgs.git-lfs}/bin/git-lfs clean -- %f";
    programs.git.extraConfig."filter \"lfs\"".process = "${pkgs.git-lfs}/bin/git-lfs filter-process";
    programs.git.extraConfig."filter \"lfs\"".required = true;
    programs.git.extraConfig."filter \"lfs\"".smudge = "${pkgs.git-lfs}/bin/git-lfs smudge -- %f";
    programs.git.extraConfig."http \"https://gopkg.in\"".followRedirects = true;
    programs.git.extraConfig."mergetool \"nvimdiff\"".cmd = "${pkgs.neovim}/bin/nvim -c Gvdiff $MERGED";
    programs.git.extraConfig.branch.autosetupmerge = false;
    programs.git.extraConfig.branch.autosetuprebase = "always";
    programs.git.extraConfig.color.ui = true;
    programs.git.extraConfig.core.autocrlf = false;
    programs.git.extraConfig.core.editor = config.resources.programs.editor.executable.path;
    programs.git.extraConfig.core.excludesfile = toString gitignore;
    programs.git.extraConfig.core.pager = "${pkgs.gitAndTools.delta}/bin/delta --theme='base16'";
    programs.git.extraConfig.core.safecrlf = false;
    programs.git.extraConfig.diff.colorMoved = "zebra";
    programs.git.extraConfig.diff.renames = "copy";
    programs.git.extraConfig.diff.tool = "nvimdiff";
    programs.git.extraConfig.fetch.prune = true;
    programs.git.extraConfig.format.pretty = "%C(auto)%h - %s%d%n%+b%+N(%G?) %an <%ae> (%C(blue)%ad%C(auto))%n";
    programs.git.extraConfig.ghq.root = "~/src";
    programs.git.extraConfig.http.cookieFile = "~/.gitcookies";
    programs.git.extraConfig.hub.protocol = "https";
    programs.git.extraConfig.interactive.diffFilter = "${pkgs.gitAndTools.delta}/bin/delta --theme='base16' --color-only";
    programs.git.extraConfig.merge.conflictstyle = "diff3";
    programs.git.extraConfig.merge.tool = "nvimdiff";
    programs.git.extraConfig.pull.rebase = "true";
    programs.git.extraConfig.push.default = "nothing";
    programs.git.extraConfig.rebase.autosquash = true;
    programs.git.extraConfig.rerere.enabled = true;
    programs.git.extraConfig.status.branch = true;
    programs.git.extraConfig.status.short = true;
    programs.git.extraConfig.status.showUntrackedFiles = "all";
    programs.git.extraConfig.status.submoduleSummary = true;
    programs.git.signing.key = config.resources.gpg.publicKey.fingerprint;
    programs.git.signing.signByDefault = true;
    programs.git.userEmail = config.resources.email;
    programs.git.userName = config.resources.fullName;

    programs.zsh.shellAliases.git="${pkgs.gitAndTools.hub}/bin/hub";
    programs.zsh.shellAliases.ga="git add";
    programs.zsh.shellAliases.gap="git add -p";
    programs.zsh.shellAliases.gb="git branch";
    programs.zsh.shellAliases.gB="git rebase";
    programs.zsh.shellAliases.gBi="git rebase -i";
    programs.zsh.shellAliases.gBI="git rebase -i --no-autosquash";
    programs.zsh.shellAliases.gBc="git rebase --continue";
    programs.zsh.shellAliases.gBs="git rebase --skip";
    programs.zsh.shellAliases.gC="git commit -am";
    programs.zsh.shellAliases.gc="git commit";
    programs.zsh.shellAliases.gca="git commit --amend";
    programs.zsh.shellAliases.gcf="git commit --fixup";
    programs.zsh.shellAliases.gcm="git commit -m";
    programs.zsh.shellAliases.gd="git diff";
    programs.zsh.shellAliases.gdc="git diff --cached";
    programs.zsh.shellAliases.gf="git fetch --all --prune";
    programs.zsh.shellAliases.gl="git log --stat --date=short";
    programs.zsh.shellAliases.gL="git log --patch-with-stat";
    programs.zsh.shellAliases.gm="git cherry-pick";
    programs.zsh.shellAliases.gM="git merge";
    programs.zsh.shellAliases.gmc="git cherry-pick --continue";
    programs.zsh.shellAliases.gms="git cherry-pick --skip";
    programs.zsh.shellAliases.gn="git checkout";
    programs.zsh.shellAliases.gnb="git checkout -b";
    programs.zsh.shellAliases.gno="git checkout --orphan";
    programs.zsh.shellAliases.gp="git pull";
    programs.zsh.shellAliases.gP="git push";
    programs.zsh.shellAliases.gpp="git pull --prune";
    programs.zsh.shellAliases.gPp="git push --prune";
    programs.zsh.shellAliases.gr="git remote";
    programs.zsh.shellAliases.gR="git reset";
    programs.zsh.shellAliases.gra="git remote add";
    programs.zsh.shellAliases.gRh="git reset --hard";
    programs.zsh.shellAliases.grl="git reflog";
    programs.zsh.shellAliases.gS="git show";
    programs.zsh.shellAliases.gs="git status";
    programs.zsh.shellAliases.gT="git tag";
    programs.zsh.shellAliases.gt="git tree";
    programs.zsh.shellAliases.gtt="git tree --all";
    programs.zsh.shellAliases.gy="git stash";
    programs.zsh.shellAliases.gyd="git stash drop";
    programs.zsh.shellAliases.gyp="git stash pop";
  }
