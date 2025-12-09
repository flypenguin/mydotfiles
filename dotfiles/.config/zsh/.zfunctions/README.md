# Detailed explanation of this ZFUCNTIONS ...

(thanks to ChatGPT)


This is NOT a standard zsh function, this is a "framework-function" from prezto, oh-my-zsh, etc.
Placing files into this directory requires an "autoload ..." command (see next one).

"autoload" registers functions to be auto-loaded on first use to reduce startup times. This is ...
NOT entirely straight-forward though, kinda like something I would do ;) . This is how it works:

  - you do `autoload -Uz $ZFUNCDIR/*(:t)` (breakdown of the command later)
  - now, each file is registered as a function. maybe. or function like.
    KICKER is: it is now available as a command and auto-loaded first time it is used.


## limitations

about the file name:

  - DASHES ARE NOT ALLOWED in the file name.


## how the files are treated

about the file's content. let's assume we have a file called `superfunc` inside `$ZFUNCDIR`:

  - you can place a function inside of the file (e.g. `my-superfunc() {}`) _or not_.

now, **for all executions of that file, one this is common: the "script" is executed in the current
shell, and does _not_ spawn a sub-shell**. that means, if you do `exit` in that script, your
_current shell_ implodes immediately.

now, the difference between function and non-function content, starting with **non-function
content:**

  - each file with _no_ function is registered as auto load on use, and the file's contents (a
    normal script, except for the non-usage of `exit`, right? ;) is executed.
  - the "function" will be available as the file name, so it can't have dashes within.
  - you can have aliases to the function by placing symlinks to the file in `$ZFUNCDIR`, which also
    can't have dashes in their file name.
  - obviously, "one command per file".

"function-content" (i.e. `my-func-1() {...} ; my-func-2() {...} ; ...`") behaves a bit differently:

  - each file is parsed, and the _functions within_ are registered. the file is then (like above)
    auto-sourced on first use of the function.
  - the file name has no effect. it's just a file with a random name.
  - function names _can_ have dashes now.
  - aliases are _not_ being done via symlinks, because the _function name_ counts now.


## how auto-loading works

let's break down autoload:

```shell
autoload -Uz $ZFUNCDIR/*(:t)
```

  - _known_ file suffixes (e.g. `.zsh` will be ignored).
    - note: **KNOWN** file suffixes.
    - also note: **files with UNKNOWN SUFFIXES are NOT LOADED.**
  - the file is first fully evaluated on first use, not on first parse.
  - `-U` means that aliases (e.g. `alias ll="ls -l"`) within the files / functions are _not_
    evaluated on _load_, but on _first exection_. seems good.
  - `-z` means that zsh will treat the file's content as _native ZSH "code"_, i.e. assuming that it
    behaves like a "proper zsh" and does not enable compatibility mode for other shells.
    let's simply use this and be happy.
  - `.../*(:t)` will strip the path from the "*" list, keeping only the file name.
    - note that the "standard" seems to be `.../*(.:t)`, which _ignores symlinks_. if you do that
      you cannot (obviously) use symlink-aliases for the function names.

after extensive chatgpt consultation, we use ...

```shell
autoload -Uz $ZFUNCTIONS/*(N~*.md:t)
```

... which does this:

  - `*`: all files in `$ZFUNCTIONS`
  - `:t`:  strip the directory (get the filename)
  - `~*.md`: exclude files ending in `.md` (this file ;)
  - `N`: nullglob, avoids errors if no matches

uff.
