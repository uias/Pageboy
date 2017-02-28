<p align="center">
    <img src="Artwork/logo.png" width="890" alt="Pageboy"/>
</p>
[![Build Status](https://travis-ci.org/MerrickSapsford/Pageboy.svg?branch=develop)](https://travis-ci.org/MerrickSapsford/Pageboy)
[![CocoaPods](https://img.shields.io/cocoapods/v/Pageboy.svg)]()
[![codecov](https://codecov.io/gh/MerrickSapsford/Pageboy/branch/develop/graph/badge.svg)](https://codecov.io/gh/MerrickSapsford/Pageboy)

**Pageboy** is a simple, highly informative page view controller.

## Features
- [x] Simplified data source management.
- [x] Enhanced delegation; featuring exact relative positional data and reliable updates.
- [x] Infinite scrolling support.

#### Upcoming
- [ ] Automatic timer-based page transitioning.

## Installation
Pageboy is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:
```ruby
pod 'Pageboy'
```
And run `pod install`.

## Usage
### Getting Started

1) Create an instance of a `PageboyViewController` and provide it with a `PageboyViewControllerDataSource`.

```swift
class PageViewController: PageBoyViewController, PageboyViewControllerDataSource {

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

## Additional functionality

### Functions
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

### Properties
- `isInfiniteScrollEnabled`: `Bool` - Whether the page view controller should infinitely scroll  between page limits (i.e. able to continuously scroll to first page from last).
- `navigationOrientation`: `UIPageViewControllerNavigationOrientation` - The orientation that the page view controller transitions on.
- `viewControllers`: `[UIViewController]?` - The view controllers that are displayed in the page view controller.
- `currentViewController`: `UIViewController?` - The view controller that the page view controller is currently at.
- `currentIndex`: `Int?` - The page index that the page view controller is currently at.
- `currentPosition`: `CGPoint?` - The relative page position that the page view controller is currently at.

#### Interaction State
- `isScrollEnabled`: `Bool` - Whether scroll is enabled on the page view controller.
- `isDragging`: `Bool` -  Whether the page view controller is currently being dragged.
- `isScrollingAnimated`: `Bool` - Whether the page view controller is currently animating a scroll between pages.
- `isUserInteractionEnabled`: `Bool` - Whether user interaction is enabled on the page view controller.

### Types
#### Enums
- `PageIndex` - The index of a page in the page view controller.  
	- `next` - The next page if available. (n+1)
	- `previous` - The previous page if available. (n-1)
	- `first` - The first page in the view controller array.
	- `last` - The last page in the view controller array.
	- `atIndex(index: Int)` - A custom specified index.

- `NavigationDirection` - The direction that the page view controller travelled.
	- `neutral` - No movement
	- `forward` - Moved in a positive direction (Towards n+1).
	- `reverse` - Moved in a negative direction (Towards n-1).

## Contributing
Bug reports and pull requests are welcome on GitHub at [https://github.com/MerrickSapsford/Pageboy](https://github.com/MerrickSapsford/Pageboy).

## License

The library is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
