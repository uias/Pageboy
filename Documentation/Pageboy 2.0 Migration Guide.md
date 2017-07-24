# Pageboy 2.0 Migration Guide

Pageboy 2.0 is the latest major release of Pageboy; a simple, highly informative page view controller for iOS. Pageboy 2.0 introduces several API-breaking changes that should be made aware of.

This guide aims to provide an easy transition from existing implementations of Pageboy 1.x to the newest API's available in Pageboy 2.0.

## Requirements

- iOS 8.0+
- Xcode 9.0+
- Swift 4.0+

For anyone wanting to use Pageboy with a Swift 3.x project, please use the latest 1.x release.

## What's new

- **Full Swift 4 Compatibility**
- **iOS 11 Compatibility**
- **Redesigned Data Source:** `PageboyViewControllerDataSource` has been completely redesigned to promote easier reuse and configuration of view controllers.
- **Refactored Delegate:** `PageboyViewControllerDelegate` functions have been refactored to support the latest design guidelines and the redesigned data source.

## API Changes

There are significant changes to the data source and delegates associated with `PageboyViewController` in Pageboy 2.0.

### Data Source Changes
`PageboyViewControllerDataSource` has been significantly changed to provide better support for reuse and performance when using large amounts of pages. The basic gist is that rather than returning a static array of view controllers, the data source can now be provided with dynamic view controllers per page index.

```swift
// Pageboy 1.x
func viewControllers(forPageboyViewController pageboyViewController: PageboyViewController) -> [UIViewController]? {
	return [viewController1, viewController2]
}

// Pageboy 2.x
func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex {
	return 2
}
    
func viewController(for pageboyViewController: PageboyViewController,
                    at index: PageboyViewController.PageIndex) -> UIViewController? {
	return self.viewControllers[index]
}
```

The syntax for other data source methods has also been updated to conform to the latest Swift standards.

```swift
// Pageboy 1.x
func defaultPageIndex(forPageboyViewController pageboyViewController: PageboyViewController) -> PageboyViewController.PageIndex? {
	return nil
}

// Pageboy 2.x
func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
	return nil
}
```

### Delegate Changes
`PageboyViewControllerDelegate` has also been significantly modified to support the new data source functions and an updated syntax style.

#### willScrollToPage
```swift
// Pageboy 1.x
func pageboyViewController(_ pageboyViewController: PageboyViewController,
								willScrollToPageAtIndex index: Int,
								direction: PageboyViewController.NavigationDirection,
								animated: Bool)

// Pageboy 2.x
func pageboyViewController(_ pageboyViewController: PageboyViewController,
								willScrollToPageAt index: PageboyViewController.PageIndex,
								direction: PageboyViewController.NavigationDirection,
								animated: Bool)
```

#### didScrollToPosition
```swift
// Pageboy 1.x
func pageboyViewController(_ pageboyViewController: PageboyViewController,
								didScrollToPosition position: CGPoint,
								direction: PageboyViewController.NavigationDirection)

// Pageboy 2.x
func pageboyViewController(_ pageboyViewController: PageboyViewController,
								didScrollTo position: CGPoint,
								direction: PageboyViewController.NavigationDirection,
								animated: Bool)
```

#### didScrollToPage
```swift
// Pageboy 1.x
func pageboyViewController(_ pageboyViewController: PageboyViewController,
								didScrollToPageAtIndex index: Int,
								direction: PageboyViewController.NavigationDirection,
								animated: Bool)

// Pageboy 2.x
func pageboyViewController(_ pageboyViewController: PageboyViewController,
								didScrollToPageAt index: PageboyViewController.PageIndex,
								direction: PageboyViewController.NavigationDirection,
								animated: Bool)
```

#### didReload
```swift
// Pageboy 1.x
func pageboyViewController(_ pageboyViewController: PageboyViewController,
								didReload viewControllers: [UIViewController],
								currentIndex: PageboyViewController.PageIndex)
                             
// Pageboy 2.x
func pageboyViewController(_ pageboyViewController: PageboyViewController,
								didReloadWith currentViewController: UIViewController,
								currentPageIndex: PageboyViewController.PageIndex)
```

### Type Changes

- `PageboyViewController.PageIndex` is now `PageboyViewController.Page`.
- `PageboyViewController.PageIndex` refers to an `Int` `typealias` for describing raw page index values.

### Property Updates
- `pageCount` has been added to `PageboyViewController`.
- `viewControllers` has been removed from `PageboyViewController`.