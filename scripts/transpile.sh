#!/usr/bin/env bash

set -euo pipefail -x

npm run compile

npx @openzeppelin/upgrade-safe-transpiler -D

COMMIT="$(git rev-parse --short HEAD)"

git config user.name 'github-actions'
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'

git add contracts
git reset --soft master
git checkout master
git commit -m "Transpile $COMMIT"
git push origin master
