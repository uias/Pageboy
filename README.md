<p align="center">
    <img src="Artwork/logo.png" width="890" alt="Pageboy"/>
</p>

[![Build Status](https://travis-ci.org/uias/Pageboy.svg?branch=master)](https://travis-ci.org/uias/Pageboy)
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![CocoaPods](https://img.shields.io/cocoapods/v/Pageboy.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/uias/Pageboy/branch/master/graph/badge.svg)](https://codecov.io/gh/uias/Pageboy)
[![GitHub release](https://img.shields.io/github/release/uias/Pageboy.svg)](https://github.com/uias/Pageboy/releases)

**TL;DR** *UIPageViewController done properly.*

**Pageboy** is a simple, highly informative page view controller.

## Features
- [x] Simplified data source management.
- [x] Enhanced delegation; featuring exact relative positional data and reliable updates.
- [x] Infinite scrolling support.
- [x] Automatic timer-based page transitioning.
- [x] Support for custom page transitions.

## Installation
### CocoaPods
Pageboy is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:
```ruby
pod 'Pageboy'
```
And run `pod install`.

### Carthage
Pageboy is available through [Carthage](https://github.com/Carthage/Carthage). Simply install carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

Add Pageboy to your `Cartfile`:

```ogdl
github "uias/Pageboy" 
```

## Requirements
Pageboy requires iOS 9.0 or above.

## Usage
### Getting Started

1) Create an instance of a `PageboyViewController` and provide it with a `PageboyViewControllerDataSource`.

```swift
class PageViewController: PageboyViewController, PageboyViewControllerDataSource {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.dataSource = self
	}
}
```

2) Implement the `PageboyViewControllerDataSource` functions.

```swift
func viewControllers(forPageboyViewController pageboyViewController: PageboyViewController) -> [UIViewController]? {
	// return array of view controllers
	return [viewController1, viewController2]
}

func defaultPageIndex(forPageboyViewController pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex? {
	// use default index
	return nil
}

```

3) Enjoy.

### Delegation

`UIPageViewController` doesn't provide the most useful delegate methods for detecting where you are when paging; this is where Pageboy comes in. `PageboyViewControllerDelegate` provides a number of functions for being able to detect where the page view controller is, and where it's headed.

#### willScrollToPageAtIndex
Called when the page view controller is about to embark on a transition to a new page.

```swift
func pageboyViewController(_ pageboyViewController: PageboyViewController,
                             willScrollToPageAtIndex index: Int,
                             direction: PageboyViewController.NavigationDirection,
                             animated: Bool)
```

#### didScrollToPosition
Called when the page view controller was scrolled to a relative position along the way transitioning to a new page. Also provided is the direction of the transition.

```swift
func pageboyViewController(_ pageboyViewController: PageboyViewController,
                             didScrollToPosition position: CGPoint,
                             direction: PageboyViewController.NavigationDirection)
```

#### didScrollToPage
Called when the page view controller did successfully complete a scroll transition to a page.

```swift
func pageboyViewController(_ pageboyViewController: PageboyViewController,
                             didScrollToPageAtIndex index: Int,
                             direction: PageboyViewController.NavigationDirection,
                             animated: Bool)
```

#### didReload
Called when the page view controller reloads its child view controllers.

```swift
func pageboyViewController(_ pageboyViewController: PageboyViewController,
                             didReload viewControllers: [UIViewController],
                             currentIndex: PageboyViewController.PageIndex)
```

## Additional functionality

- `reloadPages` - Reload the view controllers in the page view controller. (Refreshes the data source).

	```swift
	public func reloadPages()
	```
- `scrollToPage` - Scroll the page view controller to a new page programatically.

	```swift
	public func scrollToPage(_ pageIndex: PageIndex,
                               animated: Bool,
                               completion: PageTransitionCompletion? = nil)
	```

### Transitioning
Pageboy also provides custom animated transition support. This can be customised via the `.transition` property on `PageboyViewController`. 

```swift
pageboyViewController.transition = Transition(style: .push, duration: 1.0)
```

The following styles are available: 

- `.push`
- `.fade`
- `.moveIn`
- `.reveal`

### AutoScrolling
`PageboyAutoScroller` is available to set up timer based automatic scrolling of the `PageboyViewController`:

```swift
pageboyViewController.autoScroller.enable()
```
Support for custom intermission duration and other scroll behaviors is also available.

### Properties
#### View Controller Management
- `viewControllers`: `[UIViewController]?` - The view controllers that are displayed in the page view controller.
- `currentViewController`: `UIViewController?` - The view controller that the page view controller is currently at.

#### Positional Data
- `currentIndex`: `Int?` - The page index that the page view controller is currently at.
- `currentPosition`: `CGPoint?` - The relative page position that the page view controller is currently at.

#### Interaction
- `isScrollEnabled`: `Bool` - Whether scroll is enabled on the page view controller.
- `isDragging`: `Bool` -  Whether the page view controller is currently being dragged.
- `isScrollingAnimated`: `Bool` - Whether the page view controller is currently animating a scroll between pages.
- `isUserInteractionEnabled`: `Bool` - Whether user interaction is enabled on the page view controller.
- `navigationOrientation`: `UIPageViewControllerNavigationOrientation` - The orientation that the page view controller transitions on.
- `isInfiniteScrollEnabled`: `Bool` - Whether the page view controller should infinitely scroll  between page limits (i.e. able to continuously scroll to first page from last).

## Getting In Touch
Please feel free to contact me on [Twitter](https://twitter.com/MerrickSapsford).

## Contributing
Bug reports and pull requests are welcome on GitHub at [https://github.com/uias/Pageboy](https://github.com/uias/Pageboy).

## License

The library is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
