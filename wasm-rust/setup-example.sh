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
cd www && npm install || exit
cd ../pkg && npm link && echo 'pkg:' && ls -Falk || exit
cd ../www && npm link wasm-game-of-life && echo 'www:' && ls -Falk || exit

cat <<EOF >index.js
import * as wasm from "wasm-game-of-life";

wasm.greet();
EOF

echo "Serve www..."
(cd ../www && npm run start)
