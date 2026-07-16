#!/usr/bin/env bash
cd "$(dirname "$0")"
source ./script/setup.sh

rm -rf .shell-completion && mkdir -p \
    .shell-completion/zsh \
    .shell-completion/fish \
    .shell-completion/bash

if /usr/bin/which complgen &> /dev/null; then
    complgen_bin=complgen
else
    ./script/install-dep.sh --complgen
    complgen_bin=./.deps/cargo-root/bin/complgen
fi

$complgen_bin aot ./grammar/commands-bnf-grammar.txt \
    --zsh-script .shell-completion/zsh/_aerospace \
    --fish-script .shell-completion/fish/aerospace.fish \
    --bash-script .shell-completion/bash/aerospace

# Check basic syntax
zsh -c 'autoload -Uz compinit; compinit; source ./.shell-completion/zsh/_aerospace'
fish -c 'source ./.shell-completion/fish/aerospace.fish'
bash -c 'source ./.shell-completion/bash/aerospace'
