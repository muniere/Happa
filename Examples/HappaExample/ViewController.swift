//
//  ViewController.swift
//  HappaExample
//
//  Created by Hiromune Ito on 2016/03/04.
//  Copyright © 2016年 Hiromune Ito. All rights reserved.
//

import UIKit
import Happa

enum State: String {
  case Waiting = "waiting"
  case Ready   = "ready"
  case None    = "none"
}

struct Context {
  let bools: [Bool]
  let numbers: [Int]
  let strings: [String]

  var allValid: Bool {
    return self.bools.count > 0 && self.numbers.count > 0 && self.strings.count > 0
  }

  var someValid: Bool {
    return self.bools.count > 0 || self.numbers.count > 0 || self.strings.count > 0
  }

  func append(bools bools: [Bool] = [], numbers: [Int] = [], strings: [String] = []) -> Context {
    return Context(
      bools: self.bools + bools,
      numbers: self.numbers + numbers,
      strings: self.strings + strings
    )
  }
}

class ViewController: UIViewController {

  typealias Mediator = Happa<Context>

  @IBOutlet weak var wholeStateLabel: UILabel!
  @IBOutlet weak var boolStateLabel: UILabel!
  @IBOutlet weak var numberStateLabel: UILabel!
  @IBOutlet weak var stringStateLabel: UILabel!

  @IBOutlet weak var runButton: UIButton!
  @IBOutlet weak var resetButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    let disabledColor = self.resetButton.titleColorForState(.Disabled)
    self.resetButton.setTitleColor(.redColor(), forState: .Normal)
    self.resetButton.setTitleColor(disabledColor, forState: .Disabled)

    self.updateViews(state: .None)
  }

  @IBAction func run(sender: AnyObject) {
    self.updateViews(state: .Waiting)

    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

    let mediator = self.mediator()

    self.fetchBools(mediator: mediator, completion: {
      print("\(formatter.stringFromDate(NSDate())) [INFO] Finished fetching bools")
    })

    self.fetchNumbers(mediator: mediator, completion: {
      print("\(formatter.stringFromDate(NSDate())) [INFO] Finished fetching numbers")
    })

    self.fetchStrings(mediator: mediator, completion: {
      print("\(formatter.stringFromDate(NSDate())) [INFO] Finished fetching strings")
    })
  }

  @IBAction func reset(sender: AnyObject) {
    self.updateViews(state: .None)
  }

  func updateViews(state state: State) {
    self.wholeStateLabel.text  = state.rawValue
    self.boolStateLabel.text   = state.rawValue
    self.numberStateLabel.text = state.rawValue
    self.stringStateLabel.text = state.rawValue
    self.runButton.enabled     = state != .Waiting
    self.resetButton.enabled   = state != .Waiting
  }

  func mediator() -> Mediator {
    return Mediator(
      state: Context(
        bools: [],
        numbers: [],
        strings: []
      ),
      cond: { (context: Context) -> Bool in
        return context.someValid
      },
      fire: { [weak self] (context: Context) -> Void in
        guard let wself = self else { return }
        dispatch_async(dispatch_get_main_queue(), {
          wself.wholeStateLabel.text  = context.allValid          ? State.Ready.rawValue : State.Waiting.rawValue
          wself.boolStateLabel.text   = context.bools.count > 0   ? State.Ready.rawValue : State.Waiting.rawValue
          wself.numberStateLabel.text = context.numbers.count > 0 ? State.Ready.rawValue : State.Waiting.rawValue
          wself.stringStateLabel.text = context.strings.count > 0 ? State.Ready.rawValue : State.Waiting.rawValue
          wself.runButton.enabled     = context.allValid
          wself.resetButton.enabled   = context.allValid
        })
      }
    )
  }

  func fetchBools(mediator mediator: Mediator, completion: () -> Void) {
    let delay = arc4random_uniform(10000)
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(delay) * NSEC_PER_MSEC))
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

    dispatch_after(when, queue, {
      mediator.update({ $0.append(bools: [true, false, true, true]) })
      completion()
    })
  }

  func fetchNumbers(mediator mediator: Mediator, completion: () -> Void) {
    let delay = arc4random_uniform(10000)
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(delay) * NSEC_PER_MSEC))
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

    dispatch_after(when, queue, {
      mediator.update({ $0.append(numbers: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]) })
      completion()
    })
  }

  func fetchStrings(mediator mediator: Mediator, completion: () -> Void) {
    let delay = arc4random_uniform(10000)
    let when = dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(delay) * NSEC_PER_MSEC))
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

    dispatch_after(when, queue, {
      mediator.update({ $0.append(strings: ["hello, world", "fizzbuzz"]) })
      completion()
    })
  }
}
