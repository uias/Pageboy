<p align="center">
    <img src="Artwork/logo.png" width="890" alt="Pageboy"/>
</p>

<p align="center">
    <a href="https://github.com/uias/Pageboy">
        <img src="https://github.com/uias/Pageboy/workflows/Build/badge.svg" />
    </a>
    <img src="https://img.shields.io/badge/Swift-5-orange?logo=Swift&logoColor=white" />
	<a href="https://github.com/uias/Pageboy/releases">
        <img src="https://img.shields.io/github/release/uias/Pageboy.svg" />
    </a>
    <a href="https://swift.org/package-manager/">
        <img src="https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg" />
    </a>
</p>

**TL;DR** *UIPageViewController done properly.*

## ⭐️ Features
- [x] Simplified data source management & enhanced delegation.
- [x] Dynamically insert & remove pages.
- [x] Infinite scrolling support.
- [x] Automatic timer-based page transitioning.
- [x] Support for custom animated page transitions.

## 📋 Requirements
Pageboy requires iOS 12 / tvOS 12; and is compatible with Swift 5.

## 📲 Installation

### Swift Package Manager
Pageboy is compatible with [Swift Package Manager](https://swift.org/package-manager) and can be integrated via Xcode.

### CocoaPods
Pageboy is also available through [CocoaPods](https://cocoapods.org):
```ruby
pod 'Pageboy', '~> 4.0'
```

### Carthage
Pageboy is also available through [Carthage](https://github.com/Carthage/Carthage):
```ogdl
github "uias/Pageboy" ~> 4.0
```

## 🚀 Usage
- [The Basics](#the-basics)
- [PageboyViewControllerDelegate](#pageboyViewControllerDelegate)
- [Navigation](#navigation)
- [Insertion & Deletion](#insertion-&-deletion)

### The Basics

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
func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
    return viewControllers.count
}

func viewController(for pageboyViewController: PageboyViewController,
                    at index: PageboyViewController.PageIndex) -> UIViewController? {
    return viewControllers[index]
}

func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
    return nil
}
```

### PageboyViewControllerDelegate

The delegate functions provided by a `PageboyViewController` are much more reliable and useful than what a raw `UIPageViewController` provides. You can use them to find out exactly where the current page is, and when it's moved, where it's headed.

#### willScrollToPageAtIndex
About to embark on a transition to a new page.

```swift
func pageboyViewController(_ pageboyViewController: PageboyViewController,
                           willScrollToPageAt index: Int,
                           direction: PageboyViewController.NavigationDirection,
                           animated: Bool)
```

#### didScrollToPosition
Scrolled to a relative position along the way transitioning to a new page.

```swift
func pageboyViewController(_ pageboyViewController: PageboyViewController,
                           didScrollTo position: CGPoint,
                           direction: PageboyViewController.NavigationDirection,
                           animated: Bool)
```

#### didScrollToPage
Successfully completed a scroll transition to a page.

```swift
func pageboyViewController(_ pageboyViewController: PageboyViewController,
                           didScrollToPageAt index: Int,
                           direction: PageboyViewController.NavigationDirection,
                           animated: Bool)
```

#### didReload
Child view controllers have been reloaded.

```swift
func pageboyViewController(_ pageboyViewController: PageboyViewController,
                           didReloadWith currentViewController: UIViewController,
                           currentPageIndex: PageIndex)
```

### Navigation
You can navigate programmatically through a `PageboyViewController` using `scrollToPage()`:
```swift
pageViewController.scrollToPage(.next, animated: true)
```

- Infinite scrolling can be enabled with `.isInfiniteScrollEnabled`.
- Interactive scrolling can also be controlled with `.isScrollEnabled`.

### Insertion & Deletion
Pageboy provides the ability to insert and delete pages dynamically in the `PageboyViewController`.

```swift
func insertPage(at index: PageIndex, then updateBehavior: PageUpdateBehavior)
func deletePage(at index: PageIndex, then updateBehavior: PageUpdateBehavior)
```

*This behaves similarly to the insertion of rows in `UITableView`, in the fact that you have to update the data source prior to calling any of the update functions.*

**Example:**

```swift
let index = 2
viewControllers.insert(UIViewController(), at: index)
pageViewController.insertPage(at: index)
```

*The default behavior after inserting or deleting a page is to scroll to the update location, this however can be configured by passing a  `PageUpdateBehavior` value other than `.scrollToUpdate`.*

## ⚡️ Other Extras

- `reloadData()` - Reload the view controllers in the page view controller. (Reloads the data source).
- `.navigationOrientation` - Whether to orientate the pages horizontally or vertically.
- `.currentViewController` - The currently visible view controller if it exists.
- `.currentPosition` - The exact current relative position of the page view controller.
- `.currentIndex` - The index of the currently visible page.
- `.parentPageboy` - Access the immediate parent `PageboyViewController` from any child view controller.

### Animated Transitions
Pageboy also provides custom transition support for **animated transitions**. This can be customized via the `.transition` property on `PageboyViewController`.

```swift
pageboyViewController.transition = Transition(style: .push, duration: 1.0)
```

*Note: By default this is set to `nil`, which uses the standard animation provided by `UIPageViewController`.*

### Auto Scrolling
`PageboyAutoScroller` is available to set up timer based automatic scrolling of the `PageboyViewController`:

```swift
pageboyViewController.autoScroller.enable()
```

Support for custom intermission duration and other scroll behaviors is also available.

## 👨🏻‍💻 About
- Created by [Merrick Sapsford](https://github.com/msaps) ([@MerrickSapsford](https://twitter.com/MerrickSapsford))
- Contributed to by a growing [list of others](https://github.com/uias/Pageboy/graphs/contributors).

## ❤️ Contributing
Bug reports and pull requests are welcome on GitHub at [https://github.com/uias/Pageboy](https://github.com/uias/Pageboy).

## 👮🏻‍♂️ License
The library is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
