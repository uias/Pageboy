# Pageboy 3 Migration Guide

Pageboy 3 is the latest major release of Pageboy; a simple, highly informative page view controller for iOS. Pageboy 3 introduces several API-breaking changes that should be made aware of.

This guide aims to provide an easy transition from existing implementations of Pageboy 2.x to the newest API's available in Pageboy 3.

## Requirements

- iOS 9.0+
- Xcode 10.0+
- Swift 4.2+

## What's new

- Added support for Swift 4.2.
- View Controllers can now be inserted and removed dynamically. 

## API Changes

### PageboyViewControllerDelegate
- Default implementations of `PageboyViewControllerDelegate` have been removed - effectively requiring all functions to be implemented.

### Functions
- `reloadPages()` is now `reloadData()`.
