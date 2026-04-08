# sentence

## Goals

### Latency

> What's the latency target?

The goal is under 0.1 seconds.

[0.1 second is about the limit for having the user feel that the system is reacting instantaneously](https://www.nngroup.com/articles/response-times-3-important-limits/#:~:text=0.1%20second%20is%20about%20the%20limit%20for%20having%20the%20user%20feel%20that%20the%20system%20is%20reacting%20instantaneously).

### Extensibility

> When the cursor is on a sentence, can I programmatically get the sentence's start position?

Yes. The Lua function `sentence.get()` gives you the start and end positions of the sentence the cursor is on. When the cursor isn't on a sentence, `sentence.get()` gives you the start and end positions of the next sentence after the cursor, or `nil` if there is none.

`sentence.get({opts})`

Gets the start and end positions of a sentence relative to a reference position.

Parameters:

`{opts}` (table?) Optional table of options with the following keys:

- `buf` (integer?) Buffer handle (default: current buffer).

- `offset` (integer?) Sentence offset relative to the reference position (default: `0`).

- `pos` (table?) 0-based reference position as `{row, col}` (default: current cursor position).

Return:

(table|nil) If a sentence is found, `{row, start_col, end_col}`. `row`, `start_col`, and `end_col` are 0-based. `start_col` is inclusive. `end_col` is exclusive. If no sentence is found, `nil`.

This convention was chosen for a few reasons:

- Most of Neovim's API uses 0-based indices and end-exclusive ranges.

- It makes `sentence.get()` easier to use from other plugins that want to extract or replace sentence text, because the returned `{row, start_col, end_col}` can be passed directly to `nvim_buf_get_text()` and `nvim_buf_set_text()` without converting rows or column bounds.

- With an exclusive end column, `end_col - start_col` gives the span's width.

- With an exclusive end column, adjacent spans fit together cleanly because one span can end exactly where the next one starts.
