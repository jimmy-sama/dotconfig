# Neovim knowledgebase

## LSP
CRTL + ] = go to function definition
CRTL + t = jump back
g + r + n = rename function in scope
K = shows function definition
:help lspconfig-all = documentation for available lsp's

## Formatting with vanilla Neovim
= + gg or = + G for formatting basic formatting from the current line to the start or the end of the file

## Formatting with lsp
vim.lsp.buf.format() gets used by LSP
.editorconfig file is used for configuring lsp formatting with for example the amount of spaces used

## Telescope
fzf and ripgrep has to be installed
fzf native extension is recommended for better and faster searching
telescope/multigrep is a 'extension' for live ripgrep searching with optional file globing
- can be started with leader + fg
- "  " + glob expression = can be used for regular globing
- " ." + fileextension = filters for given file extensions

## Window navigation
A windows is a viewport on a given buffer
CRTL + W + T moves the windows to a new tab
g + t or g + T moves between tabs
CRTL + W + CRTL + (Vim-Motion) to navigate between windows
I have a remap to just use CRTL + (Vim-Motion) to do the same thing
if there are problems with window navigation or some floating windwos that aren't in focus, just press CRTL + w multiple times that cicles through all available windows.
Problems with floating windows:
- :\[count\]fc\[lose\]\[!\]
- the bang closes all floating windows

## Quickfix
If you search somethings with telescope you can press CRTL + q to put the results into the quickfix list
you can navigate to the window, select an item and use enter so select it or,
you can also use ALT + j or ALT + k to cycle through each item and select it directly
commands associated with the quickfix list are preceded with 'c' for example:
- :cnext
- :cprev
- :cclose
- :copen
One pretty cool thing is the :cdo command, with that you can do vim commands on the entire quickfix list like:
- :cdo s/string/newString/gc to replace something everywhere in the quickfix list and check each replacement first

g + r + r puts references from the lsp inside the quickfix list
to write your own functions use setqflist (:help setqflist)
vim.diagnostic also has the setqflist function, but by default that puts every diagnostic inside the list not just for the current file, therefor you have to write your own function to filter that 
