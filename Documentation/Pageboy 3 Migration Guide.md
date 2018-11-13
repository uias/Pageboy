# Pageboy 3 Migration Guide

Pageboy 3 is the latest major release of Pageboy; a simple, highly informative page view controller for iOS. Pageboy 3 introduces several API-breaking changes that should be made aware of.

This guide aims to provide an easy transition from existing implementations of Pageboy 2.x to the newest API's available in Pageboy 3.

## Requirements

- iOS 9.0+
- Xcode 10.0+
- Swift 4.0+

## What's new

- View Controllers can now be inserted and removed dynamically.
- Fixed numerous performance and memory issues.
- Improved Swift 4 & 4.2 compatibility.

## API Changes

### PageboyViewControllerDelegate
- Default implementations of `PageboyViewControllerDelegate` have been removed - effectively requiring all functions to be implemented.

### Properties
- `showsPageControl` has now been removed completely due to [#128](https://github.com/uias/Pageboy/issues/128).

### Functions
- `reloadPages()` is now `reloadData()`.
