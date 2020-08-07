# kakoune-git-mode
[Kakoune](http://kakoune.org) plugin providing improved git interaction.

# Installation
This plugin requires the git.kak tools script that ships with Kakoune.

## Installing with plug.kak
To install with [plug.kak](https://github.com/andreyorst/plug.kak), add the
following to your kakrc, then run the `:plug-install` command:
```
plug 'jordan-yee/kakoune-git-mode' config %{
    # Suggested user mode mapping
    map global user g ': enter-user-mode git<ret>' -docstring "git mode"
}
```

## Installing manually
Download `git-mode.kak` and add it to your autoload dir, located at
`~/.config/kak/autoload/` by default.

Alternatively, add `source <filepath>/git-mode.kak` to your kakrc, with
'<filepath>' changed to wherever you like to keep your kak scripts.

Once sourced via one of methods mentioned above, optionally add a user mode
mapping to your kakrc to trigger git mode:
```
# Suggested user mode mapping
map global user g ': enter-user-mode git<ret>' -docstring "git mode"
```

# Usage
The suggested user mode binding for activating git mode is:
```
map global user g ': enter-user-mode git<ret>' -docstring "git mode"
```
The assigned mappings for repl mode were chosen to be mechanically fluid when
used with this suggested leader key.

## git mode mappings

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

## show-diff mode mappings
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

## Example Workflow
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

# Design Notes
This plugin was written with [these principles](https://github.com/jordan-yee/principles/blob/master/kakoune-plugins.md) in mind.

# TODO
- [ ] When navigating between hunks, move then to the center of the screen instead of top.
- [ ] Add aliases for git commands.
- [ ] Add options to enable/disable aliases and mappings.
