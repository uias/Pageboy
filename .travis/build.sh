#!/bin/bash
if [[ $TRAVIS_BRANCH == 'master' ]]
    fastlane deploy
else
    fastlane test
fi