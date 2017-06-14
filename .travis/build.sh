#!/bin/bash

fastlane test
if [ -z "${TRAVIS_TAG}" ]; then
    fastlane deploy
fi