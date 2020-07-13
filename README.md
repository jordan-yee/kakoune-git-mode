# kakoune-git-mode

[Kakoune](http://kakoune.org) plugin providing a custom user mode for working
with git.

## Install

This plugin requires the git.kak tools script that ships with Kakoune.

Add `git-mode.kak` to your autoload dir: `~/.config/kak/autoload/`.

Or via [plug.kak](https://github.com/andreyorst/plug.kak):

```
plug 'jordan-yee/kakoune-git-mode'
```

## Overview

This plugin adds git mode, a custom user mode mapped to `g`. If you're using
the default user mode mapping, you can trigger git mode via the key combination,
',g'.

git mode is largely a set of mappings providing quick keyboard shortcuts to the
git.kak script that ship with Kakoune, with minor enhancements.

## Usage

### git mode mappings

| key   | action           |
| ----- | ---------------- |
| s     | status           |
| l     | log              |
| L     | show last commit |
| I     | init             |
| a     | add              |
| R     | remove           |
| c     | commit           |
| x     | checkout         |
| d     | diff             |
| D     | show diff mode*  |
| <a-d> | show diff        |
| n     | next hunk*       |
| p     | previous hunk*   |
| b     | show blame       |
| h     | hide diff/blame  |

*These actions improve upon the corresponding, default Kakoune commands:
- next/previous hunk mappings run `:git update-diff` before `git next/prev-hunk`,
so as long as you save the file before using the mapping
- more on show-diff mode below

### show-diff mode
show-diff mode executes `git show-diff`, displaying changes in the gutter, and
triggers a locked user-mode with mappings for navigating the hunks using either
the standard n/p keys or j/k vi keys. This is meant to be a the primary way to
check what's changed in a file you're working on.

| key | action        |
| --- | ------------- |
| h   | hide diff     |
| s   | show diff     |
| p,k | previous hunk |
| n,j | nexk hunk     |

Example:
1. Start show-diff mode with the key combination, ',gD'.
2. Navigate through the now-visible hunks using n/p or j/k.
3. Exit show-diff mode and hide the diff indicators using the key combination,
   'h<esc>'.

## License

Thanks a lot to the author(s) of the Kakoune git wrapper script for providing
the Kakoune git commands.

MIT
