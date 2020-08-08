# Plugin: git-mode.kak
# Author: Jordan Yee
# Description: A custom user mode for working with git.
# Dependencies: This plugin uses the git.kak script that ships with Kakoune.

declare-user-mode git

# ------------------------------------------------------------------------------
# Module

# NOTE: The commands defined by this module are an alpha-level interface.
#       - Some commands may want to be renamed to reflect specific, intended
#         functionality.
#       - Some commands should probably accept arguments to pass to the command
#         they are wrapping.
#       - Docstrings for mappings vs commands should differ when the mapping
#         assumes arguments to an associated command.
provide-module git-mode %{
    
    define-command -docstring "status" \
    git-mode-status %{
        git status
    }

    define-command -docstring "log" \
    git-mode-log %{
        git log
    }

    # TODO: If *git* buffer is open, execute ':git show <commit-hash>' for the commit
    #       under the cursor. Default to no-arg if commit hash his not found (e.g.
    #       the user is viewing git status or another non-log *git* buffer). Could
    #       search for previous instance of string matching hash regex.
    define-command -docstring "show" \
    git-mode-show %{
        git show
    }

    define-command -docstring "init" \
    git-mode-init %{
        git init
    }

    define-command -docstring "add" \
    git-mode-add %{
        git add
    }

    define-command -docstring "remove" \
    git-mode-rm %{
        git rm
    }

    define-command -docstring "commit" \
    git-mode-commit %{
        git commit
    }

    define-command -docstring "quick commit (prompt for message)" \
    git-mode-commit-message %{
        prompt 'Enter commit message: ' %{ echo %sh{ git commit -m "$kak_text" } }
    }

    define-command -docstring "checkout" \
    git-mode-checkout %{
        git checkout
    }

    define-command -docstring "diff" \
    git-mode-diff %{
        git diff
    }
    
    define-command -docstring "show diff" \
    git-mode-show-diff %{
        git show-diff
    }

    define-command -docstring "update diff" \
    git-mode-update-diff %{
        git update-diff
    }

    define-command -docstring "hide diff/blame" \
    git-mode-hide %{
        git hide-blame
        git hide-diff
    }

    define-command -docstring "navigate to previous hunk" \
    git-mode-prev-hunk %{
        git update-diff
        git prev-hunk
        # center cursor vertically so hunk and surrounding context is visible
        execute-keys vc
    }

    define-command -docstring "navigate to next hunk" \
    git-mode-next-hunk %{
        git update-diff
        git next-hunk
        # center cursor vertically so hunk and surrounding context is visible
        execute-keys vc
    }

    define-command -docstring "lock hunk navigation" \
    git-mode-navigate-hunks %{
        enter-user-mode -lock hunk-nav
        git show-diff
    }

}

# TODO: This should be called explicitly in the user's config to enable module
#       overrides in the future. Is that correct?
require-module git-mode

# ------------------------------------------------------------------------------
# git mode

map global git s ': git-mode-status<ret>' -docstring 'status'
map global git l ': git-mode-log<ret>' -docstring 'log'
map global git L ': git-mode-show<ret>' -docstring 'show last commit'
# TODO: Add <i> command to open .gitignore
# TODO: Add <a-i> command to add to .gitignore
# TODO: Add <a-I> command to add parent directory to .gitignore
map global git I ': git-mode-init<ret>' -docstring 'init'
map global git a ': git-mode-add<ret>' -docstring 'add'
# capital R is used since this is a destructive operation
map global git R ': git-mode-rm<ret>' -docstring 'remove'
map global git c ': git-mode-commit<ret>' -docstring 'commit'
map global git m ': git-mode-commit-message<ret>' -docstring 'quick commit (message)'
map global git x ': git-mode-checkout<ret>' -docstring 'checkout'
map global git D ': git-mode-diff<ret>' -docstring 'diff'
map global git d ': git-mode-show-diff<ret>' -docstring 'show diff'
map global git u ': git-mode-update-diff<ret>' -docstring 'update diff'
map global git h ': git-mode-hide<ret>' -docstring 'hide diff/blame'
map global git j ': git-mode-next-hunk<ret>' -docstring 'next hunk'
map global git n ': git-mode-next-hunk<ret>' -docstring 'next hunk'
map global git k ': git-mode-prev-hunk<ret>' -docstring 'previous hunk'
map global git p ': git-mode-prev-hunk<ret>' -docstring 'previous hunk'
map global git N ': git-mode-navigate-hunks<ret>' -docstring 'lock hunk navigation'
map global git b ': git blame<ret>' -docstring 'show blame'

# ------------------------------------------------------------------------------
# hunk-nav mode

declare-user-mode hunk-nav

map global hunk-nav j ': git-mode-next-hunk<ret>' -docstring 'next hunk'
map global hunk-nav n ': git-mode-next-hunk<ret>' -docstring 'next hunk'
map global hunk-nav k ': git-mode-prev-hunk<ret>' -docstring 'previous hunk'
map global hunk-nav p ': git-mode-prev-hunk<ret>' -docstring 'previous hunk'
# TODO: Add <r> command to remove hunk under cursor, update show-diff,
#       and navigate to the next hunk.
