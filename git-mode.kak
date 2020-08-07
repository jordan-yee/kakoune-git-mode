# Plugin: git-mode.kak
# Author: Jordan Yee
# Description: A custom user mode for working with git.
# Dependencies: This plugin uses the git.kak script that ships with Kakoune.

declare-user-mode git

# -----------------------------------------------------------------------------
# Examine

map global git s ': git status<ret>' -docstring 'status'
map global git l ': git log<ret>' -docstring 'log'
# TODO: If *git* buffer is open, execute ':git show <commit-hash>' for the commit
#       under the cursor. Default to no-arg if commit hash his not found (e.g.
#       the user is viewing git status or another non-log *git* buffer). Could
#       search for previous instance of string matching hash regex.
map global git L ': git show<ret>' -docstring 'show last commit'

# -----------------------------------------------------------------------------
# Modify

# TODO: Add <i> command to open .gitignore
# TODO: Add <a-i> command to add to .gitignore
# TODO: Add <a-I> command to add parent directory to .gitignore
map global git I ': git init<ret>' -docstring 'init'
map global git a ': git add<ret>' -docstring 'add'
# capital R is used since this is a destructive operation
map global git R ': git rm<ret>' -docstring 'remove'
map global git c ': git commit<ret>' -docstring 'commit'
map global git x ': git checkout<ret>' -docstring 'checkout'

# -----------------------------------------------------------------------------
# Diff

map global git d ': git diff<ret>' -docstring 'diff'

# NOTE: Ideally, hide-diff would be invoked when exiting this mode,
#       but that doesn't seem possible atm.
declare-user-mode show-diff

define-command -hidden activate-show-diff-mode %{
    enter-user-mode -lock show-diff
    git show-diff
}

map global git D ': activate-show-diff-mode<ret>' -docstring 'show diff mode'
map global git <a-d> ': git show-diff<ret>' -docstring 'show diff'

map global show-diff h ': git hide-diff<ret>' -docstring 'hide diff'
map global show-diff s ': git show-diff<ret>' -docstring 'show diff'


define-command -hidden next-updated-hunk %{
    git update-diff
    git next-hunk
    # center cursor vertically so hunk and surrounding context is visible
    execute-keys vc
}

map global git n ': next-updated-hunk<ret>' -docstring 'next hunk'

map global show-diff n ': next-updated-hunk<ret>' -docstring 'next hunk'
map global show-diff j ': next-updated-hunk<ret>' -docstring 'next hunk'

define-command -hidden prev-updated-hunk %{
    git update-diff
    git prev-hunk
    # center cursor vertically so hunk and surrounding context is visible
    execute-keys vc
}

map global git p ': prev-updated-hunk<ret>' -docstring 'previous hunk'

map global show-diff p ': prev-updated-hunk<ret>' -docstring 'previous hunk'
map global show-diff k ': prev-updated-hunk<ret>' -docstring 'previous hunk'

# -----------------------------------------------------------------------------
# Blame

map global git b ': git blame<ret>' -docstring 'show blame'

define-command -hidden hide-diff-blame %{
    git hide-blame
    git hide-diff
}
map global git h ': hide-diff-blame<ret>' -docstring 'hide diff/blame'
