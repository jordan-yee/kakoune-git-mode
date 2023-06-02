# kakoune-git-mode
[Kakoune](http://kakoune.org) plugin providing improved Git interaction.

Mainly, this plugin provides a pre-configured set of mappings for the built-in
`:git` commands, with some extended functionaly, outlined below.

# Options
Options are provided for customizing tab-complete for a structured commit message.

| option                                 | type | example value       |
| -------------------------------------- | ---- | ------------------- |
| `git_mode_use_structured_quick_commit` | bool | true                |
| `git_mode_commit_prefixes`             | str  | 'feat::fix::docs::' |
| `git_mode_branch_label_regex`          | str  | 'SCRUM-[0-9]+'      |

# Usage
The suggested user mode binding for activating git mode is:
```
map global user g ': enter-user-mode git<ret>' -docstring "git mode"
```
The assigned mappings for repl mode were chosen to be mechanically fluid when
used with this suggested leader key.

## Default 'git' user-mode mappings
Most of these actions map directly to the stock `git` commands that ship with
Kakoune. Any differences are detailed in a subsequent section.

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

## Default 'hunk-nav' user-mode mappings
The 'hunk-nav' user-mode displays changes in the gutter, and triggers a locked
user-mode with mappings for navigating the hunks using either the n/p or j/k keys.
This user-mode is activated with the <N> key via the default 'git' user-mode.

| key | action        |
| --- | ------------- |
| j,n | next hunk     |
| k,p | previous hunk |

# Example Workflow

1. Make changes to a code file and save them.
2. Review changes in file.
   1. Activate hunk-nav mode: `<space>gN`
   3. Navigate between changes (git hunks): `j/k` or `n/p`
   4. Exit hunk-nav mode: `<esc>`
3. Stage changes: `<space>ga`
4. Commit changes: `<space>gc`<space> enter message then save `:w`
5. Check your repo's git status: `<space>gs`

# Differences to stock git commands
The following features are unique to this plugin--as opposed to those provided
by the git commands that ship with Kakoune.

**Quick Commit**
- When triggered a prompt is shown to enter a commit message
  (instead of switching to the commit message buffer)
- If the prompt is aborted, you are given the option to switch to the commit
  buffer to continue editing the message or cancel entirely.
  - While I've found the quick commit prompt to be more convenient most of the
    time, I would frequently realize I wanted to add additional details to the
    commit message body (which can only be done on the commit message buffer)
    after already having written a summary at the quick commit prompt.
  - This feature means you don't have to start over with your message if faced
    with this situation. Just press `<esc>e` to continue editing in the
    dedicated buffer.

**Structured Commit Message**
- When enabled, the quick commit prompt provides tab-completion for a
  structured commit message (e.g. Conventional Commits).
- This uses a configurable list of commit prefix keywords (e.g. 'feat', 'docs',
  'fix', etc.), plus a regex string to match a label in the current branch name.
- Example structured commit message flow:
  - Activate the quick commit prompt
  - Start typing the keyword 'fe'
  - Tab complete the keyword plus a label derived from the current branch:
    `feat: (SCRUM-1234) <your cursor is here>`

# Installation
This plugin requires the git.kak tools script that ships with Kakoune.

## Installing with plug.kak
To install with [plug.kak](https://github.com/andreyorst/plug.kak), add the
following to your kakrc, then run the `:plug-install` command:
```
plug 'jordan-yee/kakoune-git-mode' config %{
    # Set structured commit message options here
    # set-option global git_mode_use_structured_quick_commit true
    # set-option git_mode_commit_prefixes 'feat::fix::docs::refactor::build::test::style::BREAKING CHANGE::'
    # set-option git_mode_branch_label_regex 'SCRUM-[0-9]+'

    # Declare git mode with default set of mappings
    declare-git-mode

    # Suggested user mode mapping
    map global user g ': enter-user-mode git<ret>' -docstring "git mode"

    # I find this quite nice to open the lazygit client.
    map global git o ': tmux-terminal-window lazygit<ret>' -docstring "open lazygit in new window"
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
# Declare git mode with default set of mappings
declare-git-mode

# Suggested user mode mapping
map global user g ': enter-user-mode git<ret>' -docstring "git mode"

# See also the configuration options shown in the plug.kak instructions, above.
```

# Design Notes
This plugin was written with [these principles](https://github.com/jordan-yee/principles/blob/master/kakoune-plugins.md) in mind.
