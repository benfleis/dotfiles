# Claude Rules for Me

## Basis

- In all interactions and messages, be concise; when necessary to be extremely
  concise sacrifice grammar for the sake of concision.
- Please avoid "daily positive affirmations" and simply leading with "Good
  idea", etc. If you have specific concrete feedback, please share it, but skip
  the fluff.
- When editing user code, preserve cosmetic/UX choices (emojis, sigils like
  ✅/❌, decorative markers). These are intentional.

## Feedback and Code Review

When responding to feedback or review comments, push back on suggestions that
don't add clear value. Don't implement a change just to satisfy a comment -- if
a suggestion is weak or the existing code is already correct, say so.

## Plans

- At the end of a planning, please give me a list of unresolved questions to
  answer, if there are any.

## Language

"landed" code means "committed to git" (or similar if not using git). When
referring to code that Claude has added to the file system, please say that
code has been "added by me/Claude" instead of saying "landed".

## Compilation

Never use '-j$(sysctl -n hw.ncpu)' with [c]make -- let make (and ninja) handle that.

## Code references

When referencing a specific line or range of lines in code, always use
`file_path:line_number` format. Never give a bare line number without the file path.

## Tooling

Prefer jq >> python -m json.tool.

Prefer `rg` (ripgrep) over grep and `fd` over find — both are installed.
Use rg's type filters and gitignore-awareness; use fd's glob/extension flags.

## Git

Never add a `Co-Authored-By: Claude ...` trailer to commit messages. Omit it by
default -- I own the outcomes, so attribution to the assistant adds nothing.

## DuckDB projects (core, extensions, etc.)

Currently all DuckDB projects' C++ usage is limited to C++11; one exception is
that the Azure extension uses C++14 compilation for the Azure SDK but DuckDB
code remains C++11.

In sqllogictest (.test) files, separate logical segments with a labeled section
header in this style:

    # -----------------------------------------------------------------------------
    # Section Name
    #

The separator is `#` followed by 77 dashes. The trailing lone `#` line always
closes the header block. Use this consistently when writing or editing test
files in any DuckDB project.

Each `require` statement must be separated from adjacent `require` statements
by a blank line.

In test files, reference environment variables with the bare-brace `{FOO}` form
only -- never the shell-style `${FOO}` form.
