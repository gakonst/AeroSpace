# gakonst AeroSpace fork

This fork tracks an upstream release and carries the sticky-window foundation
from [upstream PR #2083](https://github.com/nikitabobko/AeroSpace/pull/2083).
The fork scopes sticky state to AeroSpace fullscreen windows: sticky never
changes a window's tiling mode, and leaving fullscreen always clears it.

The release workflow builds inside the pinned Nix development shell. Apple
Xcode and its Swift SDK remain host dependencies because they are required to
produce the macOS application bundle. Tagged builds are published as immutable
GitHub release assets. The flake package consumes that asset, so user machines
never build AeroSpace from an unpinned checkout or use Homebrew.

To update the fork:

1. Rebase a new `sticky-v<upstream-version>` branch on the matching upstream
   release tag.
2. Port the sticky commits and run `nix develop --command swift test`.
3. Push a `v<upstream-version>-sticky.<revision>` tag and wait for the release
   workflow.
4. Update the package URL and hash in `flake.nix`, then update the locked input
   in the dotfiles flake.
