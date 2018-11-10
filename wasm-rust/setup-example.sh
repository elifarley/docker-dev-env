#!/bin/sh
set -x
. $HOME/.cargo/env
export USER=app

project_dir="$HOME/wasm-game-of-life"

if test -d $project_dir; then
  echo "Project already cloned."

else
  echo "Cloning the Project Template..."
  echo 'wasm-game-of-life' | cargo generate --git https://github.com/rustwasm/wasm-pack-template
fi

cd $project_dir || exit
pwd

echo "wasm-pack..."
wasm-pack build || exit

echo "create-wasm-app..."
npm init wasm-app www || exit

echo "Serve www..."
(cd www && python -m SimpleHTTPServer 8080)
