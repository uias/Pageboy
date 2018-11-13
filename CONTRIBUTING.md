# Contributing to Pageboy

Thanks for your interest in contributing to Pageboy! Please have a read through this document for how you can help! 🎉

You can help us reach that goal by contributing. Here are some ways you can contribute:

- [Report any issues or bugs that you find](https://github.com/uias/Pageboy/issues/new)
- [Open issues for any new features you'd like Pageboy to have](https://github.com/uias/Pageboy/issues/new)
- [Implement other tasks selected for development](https://github.com/uias/Pageboy/issues?q=is%3Aissue+is%3Aopen+label%3A%22ready+for+development%22)
- [Help answer questions asked by the community](https://github.com/uias/Pageboy/issues?q=is%3Aopen+is%3Aissue+label%3Aquestion)
- [Spread the word about Pageboy](https://twitter.com/intent/tweet?text=Pageboy,%20UIPageViewController%20done%20properly:%20https://github.com/uias/Pageboy)

## Code of conduct

All contributors are expected to follow our [Code of conduct](CONDUCT.md).
Please read it before making any contributions.

## Setting up the project for development

Nice and simple, clone the repo and then open `Pageboy.xcworkspace` in Xcode. 

The `Pageboy-Example` project is useful for manually testing `Pageboy`, featuring positional debugging labels and visual cues for ensuring everything is running smoothly. 😁

## Testing

### Running tests

Tests should be added for all functionality, both when adding new behaviors to existing features, and implementing new ones.

Pageboy uses `XCTest` to run its tests, which can either be run through Xcode or by running `$ swift test` in the repository.

## Architectural overview

Here is a quick overview of the architecture of Pageboy, to help you orient yourself in the project.

### PageboyViewController

This is the core class of the project, and is the main externally facing component. The class is split up into various extensions for feature segregation to make the project easier to navigate. 

### Management

All inner view controller management is contained within the [PageboyViewController+Management](https://github.com/uias/Pageboy/blob/master/Sources/Pageboy/PageboyViewController%2BManagement.swift) extension.

This is also where the internal `UIPageViewController` instance is managed. Any additional functionality relevant to the `UIPageViewController` or management of child view controllers should be added to this extension.

### Scroll Detection

The [PageboyViewController+ScrollDetection](https://github.com/uias/Pageboy/blob/master/Sources/Pageboy/PageboyViewController%2BScrollDetection.swift)  extension handles responding to scroll updates in addition to all the functions for observing the internal scroll view. 

This extension also responds to the internal `UIPageViewControllerDelegate` and handles infinite scrolling behaviour etc.

### Transitioning

The custom transitioning support available in `Pageboy` is provided by the [PageboyViewController+Transitioning](https://github.com/uias/Pageboy/blob/master/Sources/Pageboy/Transitioning/PageboyViewController%2BTransitioning.swift) extension. In conjunction with [TransitionOperation](https://github.com/uias/Pageboy/blob/master/Sources/Pageboy/Transitioning/TransitionOperation.swift) object, custom transitioning is made available through the use of `CATransition` in place of the built in `UIPageViewController` animations.

Any updates or tweaks to animated transitioning should be made here.

## Questions or discussions

If you have a question about the inner workings of Pageboy, or if you want to discuss a new feature - feel free to [open an issue](https://github.com/uias/Pageboy/issues/new).

Happy contributing! 👨🏻‍💻
