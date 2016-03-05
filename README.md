# Happa

[![CI Status](http://img.shields.io/travis/muniere/Happa.svg?style=flat)](https://travis-ci.org/muniere/Happa)
[![Version](https://img.shields.io/cocoapods/v/Happa.svg?style=flat)](http://cocoapods.org/pods/Happa)
[![License](https://img.shields.io/cocoapods/l/Happa.svg?style=flat)](http://cocoapods.org/pods/Happa)
[![Platform](https://img.shields.io/cocoapods/p/Happa.svg?style=flat)](http://cocoapods.org/pods/Happa)

Happa is a library to control when to execute function with closed scope context.

## Requirements

- iOS 8.0+
- Xcode 7.2+

## Installation

Happa is available through [CocoaPods](http://cocoapods.org). 

Add the followings to `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!

pod "Happa"
```

Then, run the command

```bash
$ pod install
```

## Usage

This is a simple usage. See `Examples` for more complex examples.

```swift
import Happa

let context = Happa<Int>(
  state: 2,
  cond: { (current: Int) -> Bool in
    return current <= 0
  },
  fire: { (current: Int) -> Void in
    print("current value: \(current)")
  }
)

asyncFunc1(completion: {
  // not fire
  context.update { (current: Int) -> Int in
    return current - 1
  }
})

asyncFunc2(completion: {
  // fire
  context.update { (current: Int) -> Int in
    return current - 1
  }
})

asyncFunc3(completion: {
  // more fire
  context.update { (current: Int) -> Int in
    return current - 1
  }
})
```

## License

Happa is available under the MIT license. See the LICENSE file for more info.
