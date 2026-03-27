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

- `pos` (table?) Reference position as `{row, col}` (default: current cursor position).

- `offset` (integer?) Sentence offset relative to the reference position (default: `0`).

Return:

(table|nil) If a sentence is found, `{row, start_col, end_col}`. Otherwise, `nil`.
