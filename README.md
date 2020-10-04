Easily mint up pretty much every new project, based on templates.

# Installing

Installation can happen in (at least) two ways:

- by putting a self-contained Perl program [skf][] somewhere in the
  path. This is simple, requires a not-too-obsolete `perl` around and
  will require you to install the [.skfold modules][dot-skfold] manually
  (or create your own);
- using a [Docker][] image. This is also simple and requires [Docker][],
  of course.

Whatever the route you take, you end up with a `skf` command in `PATH`
so at that point:

```shell
skf --man
```

## Self-contained program

Install [skf][] somewhere in `PATH`:

```shell
curl -LO https://github.com/polettix/skfold/raw/master/skf
chmod +x skf
# mv skf /path/in/PATH
```

This comes with no module at all, so you will have to create and
populate `~/.skfold` by yourself, e.g. taking inspiration from
[dot-skfold][].


## Docker image

A [Docker][] image is available in GitHub.

First of all, you have to ensure you are logged in GitHub with the
`docker` command line tool. If you are not, follow the instracutions in
[Authenticating to GitHub Container Registry][authenticate]; this will
be needed only once.

Now you should be able to pull the image locally and use it:

```shell
export SKF_IMAGE='ghcr.io/polettix/skf:latest'
docker run --rm "$SKF_IMAGE" --wrapper 2>/dev/null
```

The command above prints out a wrapper shell function that you can e.g.
add to your `~/.bashrc` or `~/.profile`, or just install in the current
shell like this:

```shell
eval "$(docker run --rm "$SKF_IMAGE" --wrapper 2>/dev/null)"
```

Now you have a `skf` function in your environment that allows you to
call the docker image like it's a command-line tool.


# Hacking

Use [Carton][] to install the modules using the `cpanfile`.

```shell
carton install --deployment
```

To regenerate the fat-packed version run:

```shell
bin/fat-pack
```

To regenerate the dibs image run:

```shell
dibs/ify
```


# COPYRIGHT & LICENSE

The contents of this repository are licensed according to the Apache
License 2.0 (see file `LICENSE` in the project's root directory):

>  Copyright 2020 by Flavio Poletti
>
>  Licensed under the Apache License, Version 2.0 (the "License");
>  you may not use this file except in compliance with the License.
>  You may obtain a copy of the License at
>
>      http://www.apache.org/licenses/LICENSE-2.0
>
>  Unless required by applicable law or agreed to in writing, software
>  distributed under the License is distributed on an "AS IS" BASIS,
>  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
>  See the License for the specific language governing permissions and
>  limitations under the License.
>
>  Dedicated to the loving memory of my mother.

[Carton]: https://metacpan.org/pod/Carton
[skf]: https://github.com/polettix/skfold/raw/master/skf
[dot-skfold]: https://github.com/polettix/skfold/tree/master/dot-skfold
[Docker]: https://www.docker.com/
[authenticate]: https://docs.github.com/en/free-pro-team@latest/packages/managing-container-images-with-github-container-registry/pushing-and-pulling-docker-images#authenticating-to-github-container-registry
