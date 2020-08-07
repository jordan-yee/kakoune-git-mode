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

There are many useful scripts that ship with Kakoune to provide commands for
working with external programs such as git. It is standard convention to leave
it to the user to create custom mappings for these commands. This plugin
initially aims to provide a ready-to-go set of mappings for using the git
commands that come with Kakoune.

Additionally, the goal of this plugin is to streamline interaction with git
during development so far as makes sense to do so from within Kakoune. To that
end, git-mode mappings and other functionality will be incrementally updated to
improve upon the behavior of the built-in git commands.

## Usage

### git mode mappings

| key     | action           |
| ------- | ---------------- |
| s       | status           |
| l       | log              |
| L       | show last commit |
| I       | init             |
| a       | add              |
| R       | remove           |
| c       | commit           |
| x       | checkout         |
| d       | diff             |
| D       | show diff mode*  |
| \<a-d\> | show diff        |
| n       | next hunk*       |
| p       | previous hunk*   |
| b       | show blame       |
| h       | hide diff/blame  |

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

### Example Workflow

NOTE: In steps below, KC means Key Combination.

1. Make changes to code file and save them.
2. Review changes in file.
   1. Activate show-diff mode.
      KC: `,gD`
   3. Navigate between changes (git hunks).
      KC: `j/k` or `n/p`
   4. Hide changes and exit show-diff mode.
      KC: `h<esc>`
3. Stage changes.
   KC: `,ga`
4. Commit changes.
   KC: `,gc`
5. Check your repo's git status.
   KC: `,gs`

### TODO

- [ ] Add option for specifying an alternate user mode key.
- [ ] Add aliases for git commands.
- [ ] Add options to enable/disable aliases and mappings.
