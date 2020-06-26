skf() {
   : ${SKF_IMAGE:="docker.pkg.github.com/polettix/skfold/skf:latest"}
   docker run --rm \
      -v "$PWD:/mnt" \
      -v "$HOME/.skfold/defaults.json:/app/.skfold/defaults.json:ro" \
      "$SKF_IMAGE" "$@"
}
