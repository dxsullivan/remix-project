#!/usr/bin/env bash

set -e

BUILD_ID=${CIRCLE_BUILD_NUM:-${TRAVIS_JOB_NUMBER}}
echo "$BUILD_ID"
TEST_EXITCODE=0

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

cd ..
echo $SHELL
ls -la .
pwd
# install foundry
curl -L https://foundry.paradigm.xyz | bash || true
# export /home/circleci/.foundry/bin to PATH
export PATH=$PATH:/home/circleci/.foundry/bin
foundryup
mkdir foundry
cd foundry
ls -la .
forge init hello_foundry
ls -la hello_foundry
cd ..

# install truffle with yarn
yarn global add truffle
# install truffle metacoin box
mkdir MetaCoin
cd MetaCoin
truffle unbox metacoin
cd ..

# install hardhat
yarn global add hardhat


sleep 5

cd remix-project
yarn run build:e2e

echo "$TEST_EXITCODE"
if [ "$TEST_EXITCODE" -eq 1 ]
then
  exit 1
fi
