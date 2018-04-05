![Boost: Enterprise AppStore in Swift](https://github.com/LiveUI/Reloaded/raw/master/Other/logo.jpeg)

# CoreData - Reloaded

A brand new Swift abstraction layer for CoreData's original interface


[![Slack](https://img.shields.io/badge/join-slack-745EAF.svg?style=flat)](http://bit.ly/2B0dEyt)
[![Jenkins](https://ci.liveui.io/job/LiveUI/job/Boost/job/master/badge/icon)](https://ci.liveui.io/job/LiveUI/job/Reloaded/)
[![Platforms](https://img.shields.io/badge/platforms-iOS%20|%20macOS|%20tvOS|%20watchOS-ff0000.svg?style=flat)](http://cocoapods.org/pods/Reloaded)
[![Swift 4](https://img.shields.io/badge/swift-4.1-orange.svg?style=flat)](http://swift.org)
[![Version](https://img.shields.io/cocoapods/v/Reloaded.svg?style=flat)](http://cocoapods.org/pods/Reloaded)
[![License](https://img.shields.io/cocoapods/l/Reloaded.svg?style=flat)](http://cocoapods.org/pods/Reloaded)


##

> <b style="color:red;">Warning! - *Project is not yet completely finished. We are going to release an alpha version in April, contact us on Slack for ETA or follow the status below*</b>

## Setup data model

Well ,this is exactly the same process as you would do when setting up core data the old way. If you haven't created your app from a template, just:
* create a new **Data Model** file
* give it the same name as your bundle has (Reloaded is trying to use `kCFBundleNameKey` to generate the expected name)
* Create your entities as you would

## Basic usage

> If you don't have your data model <i>(.xcdatamodeld)</i> file yet, jump to the [Setup data model](#setup-data-model) section and then come back.

Using <b>Reloaded</b> is super simple, in the basic configuration you don't have to write a single line of setup you would probably otherwise have in your `AppDelegate` but you can obviously still leverage your apps delegate methods as you would otherwise.

```swift
import Reloaded

// Conform your NSManagedObject to Reloaded own protocol `Entity`
extension Locomotive: Entity { }

// Creating a new object
let loco = try! Locomotive.new()
loco.color = "black"
loco.hasChimney = true

// Save an object
try! loco.save()

// Fetching all black locomotives with a chimney sorted by color
let all = try! Locomotive.query.filter("color" == "red", "hasChimney" == true).sort(by: "color", direction: .orderedDescending).all()
print(all)
```


