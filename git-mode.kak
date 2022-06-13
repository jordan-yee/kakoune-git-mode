# Plugin: git-mode.kak
# Author: Jordan Yee
# Description: A custom user mode for working with git.
# Dependencies: This plugin uses the git.kak script that ships with Kakoune.

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

    # --------------------------------------
    # Options

    # TODO: add custom structured message format option
    # Currently, the generated format may not quite follow the conventional commit spec

    # TODO: provide a way to use project-specific configuration

    declare-option -hidden -docstring "tab-complete structured message in quick commit prompt" \
    bool git_mode_use_structured_quick_commit false

    declare-option -docstring "
    list of structured commit message prefixes

    used for tab-completion of structured commit message

    each keyword must be followed by 2 colons (::) to be parsed correctly
    " \
    str git_mode_commit_prefixes 'feat::fix::docs::refactor::build::test::style::BREAKING CHANGE::'

    declare-option -docstring "
    regex pattern used against current git branch name to get structured commit message label

    For example:
      if this is set to 'SCRUM-[0-9]+' and the branch name is 'jy/SCRUM-1234-description',
      then a structured commit message will tab complete to:
        `<prefix>: (SCRUM-1234) `
      where `<prefix>` is from the `git_mode_commit_prefixes` list.
    " \
    str git_mode_branch_label_regex 'SCRUM-[0-9]+'

    # --------------------------------------
    # Commands

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

    define-command -hidden -docstring "commit with message from prompt" \
    git-mode-commit-message-from-prompt %{
        echo %sh{ git commit -m "$kak_text" }
    }

    define-command -hidden -docstring "enable switching to commit buffer on quick commit abort" \
    git-mode-quick-commit-on-abort %{
        # If a commit buffer was previously created, reset it
        try %{ delete-buffer! .git/COMMIT_EDITMSG }

        # Transfer what's been typed in the prompt so far to the commit buffer
        set-register c %val{text}
        hook -once -group prefill global WinDisplay .* %{
            evaluate-commands %sh{
                printf "%s\n" 'execute-keys \"cP'
            }
        }

        # Prompt for action and handle input
        info "Press 'e' to continue editing message in commit buffer, or any other key to abort..."
        on-key %{
            execute-keys <esc>
            evaluate-commands %sh{
                case $kak_key in
                    'e') printf %s "git commit" ;;
                    *) printf %s "remove-hooks global prefill; echo 'aborted commit'" ;;
                esac
            }
        }
    }

    define-command -docstring "quick commit (prompt for message)" \
    git-mode-commit-message %{
        prompt -on-abort %{ git-mode-quick-commit-on-abort } \
        'Enter commit message: ' %{ git-mode-commit-message-from-prompt }
    }

    define-command -docstring "structured quick commit (prompt for message)" \
    git-mode-commit-structured-message %{
        prompt -on-abort %{ git-mode-quick-commit-on-abort } \
        -shell-script-candidates "
        # NOTE: The grep -P strategy may not be posix compliant!
        jira_label=$(echo $(git branch --show-current) \
                   | grep -P -o ""$kak_opt_git_mode_branch_label_regex"" \
                   | sed 's/^/\(/;s/$/\) /')
        echo $kak_opt_git_mode_commit_prefixes | sed -e ""s/::/: $jira_label\n/g""
        " \
        'Enter commit message: ' %{ git-mode-commit-message-from-prompt }
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

    define-command -docstring "declare 'git' user-mode with a default set of mappings" \
    declare-git-mode %{
        # --------------------------------------
        # git mode

        declare-user-mode git

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
        evaluate-commands %sh{
            if [ $kak_opt_git_mode_use_structured_quick_commit = 'true' ]; then
                printf %s "map global git m ': git-mode-commit-structured-message<ret>' -docstring 'quick commit'"
            else
                printf %s "map global git m ': git-mode-commit-message<ret>' -docstring 'quick commit'"
            fi
        }
        map global git x ': git-mode-checkout<ret>' -docstring 'checkout'
        map global git D ': git-mode-diff<ret>' -docstring 'diff'
        map global git d ': git-mode-show-diff<ret>' -docstring 'show diff'
        map global git u ': git-mode-update-diff<ret>' -docstring 'update diff'
        map global git j ': git-mode-next-hunk<ret>' -docstring 'next hunk'
        map global git n ': git-mode-next-hunk<ret>' -docstring 'next hunk'
        map global git k ': git-mode-prev-hunk<ret>' -docstring 'previous hunk'
        map global git p ': git-mode-prev-hunk<ret>' -docstring 'previous hunk'
        map global git N ': git-mode-navigate-hunks<ret>' -docstring 'lock hunk navigation'
        map global git b ': git blame<ret>' -docstring 'show blame'
        map global git h ': git-mode-hide<ret>' -docstring 'hide diff/blame'

        # --------------------------------------
        # hunk-nav mode

        declare-user-mode hunk-nav

        map global hunk-nav j ': git-mode-next-hunk<ret>' -docstring 'next hunk'
        map global hunk-nav n ': git-mode-next-hunk<ret>' -docstring 'next hunk'
        map global hunk-nav k ': git-mode-prev-hunk<ret>' -docstring 'previous hunk'
        map global hunk-nav p ': git-mode-prev-hunk<ret>' -docstring 'previous hunk'
    }

}

# TODO: This should be called explicitly in the user's config to enable module
#       overrides in the future. Is that correct?
require-module git-mode
