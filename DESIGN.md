These are a few design notes to get this project going.

- The resulting program MUST be fat-packable for easy portability. Embedding in
  [Docker][] can be considered but is sub-optimal and should only address lack
  of [Perl][].

- **KISS**: no fancy inclusions for modularization and reuse, at least in
  this initial phase. This is probably what got somehow wrong with
  App-Scaffold. There can be 1 (one) generic directory with default stuff
  that can be applied to any sub-module, use sparingly. Also, there is
  1 (one) overall default configuration for setting variables, treated as
  a hash with first-level overriding of values only. *Nothing fancier*.

- **How to call it**: this is *really* the most important part, probably. It
  MUST be kept simple and easily remembered. It MUST be easy to know what the
  options are.

  - Calling without parameters provides useful information, like e.g.
    a synthetic explanation of the calling convention as well as a list of
    the available sub-modules to scaffold specific projects.

```shell
$ skf

Call as:

  skf --help         # gives you extensive help
  skf --man          # man page
  skf -h <module>    # help on a sub-module

  skf [skf-parameters] <target> <module> [module-specific-parameters...]

Available modules:

- foo
- bar
- bazify

```

    - Overall options `--version`, `--help` and `--man` work. Option
      `--usage` is the same as no-option as indicated above.

    - Overall option `-h` requires mandatory name of module and provides
      help on that module.

    - Overall option `-b`/`--base` is the base directory for `skf` stuff.
      It defaults to `~/.skfold/`

- The structure of the base directory is the following:

```text
<base>/
  |- default/
  |- modules/
```

    - Each module has its own directory inside `modules` with the
      following structure:

```text
<base>/modules/<module>/
  |- config.json
  |- post.pl
  |- pre.pl
  |- templates/
```

    - The `default` directory contains a `defaults.json` with default
      key/value pairs (for missing options) and `templates/`:

```text
<base>/default/
  |- defaults.json
  |- templates/
```

- File `config.json` is loaded into a `$config` anonymous hash

    - `$config->{cmdline_options}` contains options for `Getopt::Long`,
      called with the `gnu_getopt` configuration option. The command line:

    - is parsed according to this configuration into `$config->{options}`;
    - defaults in `$config->{defaults}` are merged in
    - `defaults.json` key/value pairs from the `default` directory are
      merged in
    - the `<target>` parameter is assigned to the `target` key, overriding
      anything else
    - the `target-dir` key is set to `<target>` as well

- If present, file `pre.pl` is loaded (via `do`) and it is supposed to
  return a reference to a function. This function is called with parameter
  `$config` to possibly expand/modify it (e.g. set a different
  `target-dir`, or massage the list of files)

- The `$config->{'target-dir'}` is created and set as the base for the
  newly minted project

- The structure of the target directory is described inside key `files`.
  This is an *array of hashes*, containing:

    - `source`: (optional) a [Template::Perlish][] template in the
      `templates/` directory. If missing, the destination represents
      a directory
    - `destination`: the path of the destination file, relative to the
      `target-dir`
    - `mode`: file/directory creation mode

- If `$config->{git-init}` is *true*, the newly created directory is
  initialized as a [Git][] directory.

- If present, file `post.pl` is loaded (via `do`), and it is supposed to
  return a reference to a function. This function is called with `$config`
  as parameter, to perform post-operations that might be needed.

# Packing

Packing - fat-packing, actually - is done within the [Docker][] image. This
allows leveraging [Docker][] for what it does best - keeping prerequisites in a
tight space.


[Docker]: https://www.docker.com/
[Perl]: https://www.perl.org/
[Template::Perlish]: https://metacpan.org/pod/Template::Perlish
[Git]: https://www.git-scm.com/
