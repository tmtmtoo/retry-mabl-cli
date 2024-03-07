set dotenv-load

default:
  @just --list

fmt:
  -@nix fmt
  -@shfmt -l -w *.sh

lint:
  @shellcheck *.sh

test:
  @shellspec -P "*.spec"
