//
//  Happa.swift
//  Happa
//
//  Created by Hiromune Ito on 2016/03/04.
//  Copyright © 2016年 Hiromune Ito. All rights reserved.
//

import Foundation

public class Happa<T> {

  /// Current value
  public internal(set) var state: T
  public internal(set) var count: Int = 0

  let cond: (T) -> Bool
  let fire: (T) -> Void

  /**
   Create a new hakka with initial state

   - parameter state: Initial state
   - parameter cond:  fire if cond is true
   - parameter fire:  Execute some process
   */
  public init(state: T, cond: (T) -> Bool, fire: (T) -> Void) {
    self.state = state
    self.cond = cond
    self.fire = fire
  }

  /**
   Update current value with delta

   - parameter next: Generate next value

   - returns: True if fired, else false
   */
  public func update(next: (T) -> T) -> Bool {
    self.state = next(self.state)

    if self.cond(self.state) {
      self.fire(self.state)
      self.count++
      return true
    } else {
      return false
    }
  }
}
