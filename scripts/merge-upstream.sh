#!/usr/bin/env bash

set -euo pipefail -x

git fetch 'https://github.com/OpenZeppelin/openzeppelin-contracts.git'
git config user.name 'github-actions'
git config user.email '41898282+github-actions[bot]@users.noreply.github.com'
git merge FETCH_HEAD -m 'Merge upstream openzeppelin-contracts into upstream-patched'
git push
