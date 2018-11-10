#!/bin/sh

project_dir="$HOME/wasm-pack build"

if test -d $project_dir; then
  echo "Project already cloned."

else
  echo "Cloning the Project Template..."
  echo 'wasm-game-of-life' | cargo generate --git https://github.com/rustwasm/wasm-pack-template
fi

echo "wasm-pack..."
wasm-pack build

echo "create-wasm-app..."
npm init wasm-app www
