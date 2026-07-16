#!/usr/bin/env bash
cd "$(dirname "$0")"
source ./script/setup.sh

rm -rf .shell-completion && mkdir -p \
    .shell-completion/zsh \
    .shell-completion/fish \
    .shell-completion/bash

if /usr/bin/which complgen &> /dev/null; then
    complgen ./grammar/commands-bnf-grammar.txt --zsh .shell-completion/zsh/_aerospace
    complgen ./grammar/commands-bnf-grammar.txt --fish .shell-completion/fish/aerospace.fish
    complgen ./grammar/commands-bnf-grammar.txt --bash .shell-completion/bash/aerospace
else
    ./script/install-dep.sh --complgen
    ./.deps/cargo-root/bin/complgen aot ./grammar/commands-bnf-grammar.txt \
        --zsh-script .shell-completion/zsh/_aerospace \
        --fish-script .shell-completion/fish/aerospace.fish \
        --bash-script .shell-completion/bash/aerospace
fi

# Check basic syntax
zsh -c 'autoload -Uz compinit; compinit; source ./.shell-completion/zsh/_aerospace'
fish -c 'source ./.shell-completion/fish/aerospace.fish'
bash -c 'source ./.shell-completion/bash/aerospace'
