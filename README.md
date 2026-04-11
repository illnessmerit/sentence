# sentence

## Make Sentence Make Sense

`sentence` is sentence motions and text objects built for prose.

## Setup

> How do I set up `sentence`?

1. Make sure you're using a Mac.

1. Install [Homebrew](https://brew.sh/#install).

1. Open a terminal.

1. Run the following commands:

   ```bash
   brew install node
   npm install -g neovim
   ```

1. Make sure you're using [`lazy.nvim`](https://github.com/folke/lazy.nvim).

1. Add this block to your `lazy.nvim` configuration:

   ```lua
   {
     "nvim-mini/mini.nvim",
     config = function()
       require("mini.ai").setup({
         custom_textobjects = {
           s = require("sentence").ai,
         },
       })
     end,
     dependencies = { "8ta4/sentence" },
   }
   ```

## Usage

> Will the `)` motion stop on blank lines?

No. The `)` motion bypasses blank lines. This keeps you moving between thoughts, instead of landing on dead space.

> From Normal mode, can `vis` select anything if the cursor is on a blank line?

Yes. Instead of selecting nothing on a blank line, `vis` selects the next sentence, if one exists.

> From Normal mode, with the cursor on a sentence, does `vas` select its trailing whitespace?

Yes. `as` selects the trailing whitespace, so operations like `das` don't leave your text messy. `is` selects only the sentence text. This gives `is` and `as` distinct purposes, so you're not wasting keys on redundant behavior.

> From Normal mode, with the cursor on a sentence, can `vas` select leading whitespace?

Yeah. If there's no trailing whitespace after the sentence, `as` grabs the leading whitespace before it instead. This way, `das` doesn't leave your text messy, and `is` and `as` stay distinct.

> Can `sentence` treat text spanning multiple lines as a single sentence?

No. If a line contains any non-whitespace character, then the last non-whitespace character on that line is a sentence end. This plays nice with soft wrapping for prose paragraphs and makes sure unpunctuated list items stay separate.

A sentence can also end earlier within the same line. This happens when a `?` or `!` is followed by an optional `)`, `]`, `"` or `'`, and then by whitespace. In that case, the sentence end is the last character before that whitespace.

A `.` works the same way, except in two cases.

- If the `.` is part of an unambiguous abbreviation like `Mr.`, `Dr.`, `Mrs.` or `Ms.`, and non-whitespace text follows on the same line, then that `.` is not treated as a sentence end.

- If the line begins with optional indentation, then one or more digits, then a `.`, and non-whitespace text follows on the same line, then that `.` is not treated as a sentence end.

`sentence` avoids rules for ambiguous cases like `Jr.` because those kinds of rules could lead the plugin to treat two separate linguistic sentences as one. That way, the rules stay simple.
