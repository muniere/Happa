//
//  HappaTests.swift
//  HappaTests
//
//  Created by Hiromune Ito on 2016/03/04.
//  Copyright © 2016年 Hiromune Ito. All rights reserved.
//

import XCTest
@testable import Happa

class HappaTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }

  func testFireManyTimes() {

    let context = Happa<Int>(
      state: 5,
      cond: { (value: Int) -> Bool in
        return value <= 0
      },
      fire: { (value: Int) -> Void in
        XCTAssertLessThanOrEqual(value, 0)
      }
    )

    (0..<10).forEach { _ in
      context.update({ (value: Int) -> Int in
        return value - 1
      })
    }

    XCTAssertEqual(context.state, -5)
    XCTAssertEqual(context.count, 6)
  }
  
  func testFireOnceAtJustTime() {

    let context = Happa<Int>(
      state: 5,
      cond: { (value: Int) -> Bool in
        return value == 0
      },
      fire: { (value: Int) -> Void in
        XCTAssertEqual(value, 0)
      }
    )

    (0..<10).forEach { _ in
      context.update({ (value: Int) -> Int in
        return value - 1
      })
    }

    XCTAssertEqual(context.state, -5)
    XCTAssertEqual(context.count, 1)
  }

  func testFireWithStringState() {

    let context = Happa<String>(
      state: "",
      cond: { (string: String) -> Bool in
        return string.characters.count >= 15
      },
      fire: { (string: String) -> Void in
        XCTAssertGreaterThanOrEqual(string.characters.count, 15)
      }
    )

    let strings = ["Hello", "World", "foobar", "fizzbuzz"]

    strings.forEach { (str: String) in
      context.update({ (value: String) -> String in
        return (value.isEmpty) ? str : [value, str].joinWithSeparator(",")
      })
    }

    XCTAssertEqual(context.state, strings.joinWithSeparator(","))
    XCTAssertEqual(context.count, 2)
  }

  func testFireWithValueState() {

    typealias State = StateStruct

    let state = State(count: 0)

    let context = Happa<State>(
      state: state,
      cond: { (state: State) -> Bool in
        return state.count > 5
      },
      fire: { (state: State) -> Void in
        XCTAssertGreaterThan(state.count, 5)
      }
    )

    (0..<10).forEach { _ in
      context.update({ (var state: State) -> State in
        return state.update(delta: 1)
      })
    }

    XCTAssertEqual(context.state.count, 10)
    XCTAssertEqual(context.count, 5)
    XCTAssertEqual(state.count, 0)
  }

  func testFireWithReferenceState() {

    typealias State = StateClass

    let state = State(count: 0)

    let context = Happa<State>(
      state: state,
      cond: { (state: State) -> Bool in
        return state.count > 5
      },
      fire: { (state: State) -> Void in
        XCTAssertGreaterThan(state.count, 5)
      }
    )

    (0..<10).forEach { _ in
      context.update({ (state: State) -> State in
        return state.update(delta: 1)
      })
    }

    XCTAssertEqual(context.state.count, 10)
    XCTAssertEqual(context.count, 5)
    XCTAssertEqual(state.count, 10)
  }
}

private class StateClass {

  var count: Int

  init(count: Int) {
    self.count = count
  }

  func update(delta delta: Int) -> StateClass {
    self.count += delta
    return self
  }
}

private struct StateStruct {

  var count: Int

  mutating func update(delta delta: Int) -> StateStruct {
    self.count += delta
    return self
  }
}
