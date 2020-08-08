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

| key     | action                            |
| ------- | --------------------------------- |
| s       | status                            |
| l       | log                               |
| L       | show last commit                  |
| I       | init                              |
| a       | add                               |
| R       | remove                            |
| c       | commit                            |
| m       | quick commit (prompt for message) |
| x       | checkout                          |
| D       | diff                              |
| d       | show diff                         |
| u       | update diff                       |
| j,n     | next hunk*                        |
| k,p     | previous hunk*                    |
| N       | lock hunk navigation              |
| b       | show blame                        |
| h       | hide diff/blame                   |

## hunk-nav mode mappings
hunk-nav mode displays changes in the gutter, and triggers a locked user-mode
with mappings for navigating the hunks using either the n/p or j/k keys. This
mode is activated with the <N> key.

| key | action        |
| --- | ------------- |
| j,n | nexk hunk     |
| k,p | previous hunk |

## Example Workflow
NOTE: In steps below, KC means Key Combination.

1. Make changes to code file and save them.
2. Review changes in file.
   1. Activate hunk-nav mode.
      KC: `,gN`
   3. Navigate between changes (git hunks).
      KC: `j/k` or `n/p`
   4. Exit hunk-nav mode.
      KC: `<esc>`
3. Stage changes.
   KC: `,ga`
4. Commit changes.
   KC: `,gc`, enter message then save `:w`
5. Check your repo's git status.
   KC: `,gs`

# Design Notes
This plugin was written with [these principles](https://github.com/jordan-yee/principles/blob/master/kakoune-plugins.md) in mind.

# TODO
- [ ] Add aliases for git commands.
- [ ] Add options to enable/disable aliases and/or mappings.
- [ ] Add option to trigger update-diff via save hook or manually (for performance).
