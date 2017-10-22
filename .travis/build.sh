#!/bin/bash

if [ "${TRAVIS_BRANCH}" = "master" ] && [ -n "${TRAVIS_TAG}" ]; then
    fastlane deploy
else
    fastlane test
fi
exit