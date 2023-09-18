//
//  Valet.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation
import Valet

extension Valet {
  /// Removes the previous value if new value set is Nil.
  func setString(value: String?, forKey: String) {
    if let value = value, value.isEmpty {
      try? removeObject(forKey: forKey)
    } else {
      try? setString(value!, forKey: forKey)
    }
  }

  func getString(forKey: String) -> String? {
    guard canAccessKeychain() else {
      return nil
    }
    return try? string(forKey: forKey)
  }

  /// Removes the previous value if new value set is Nil.
  func setData(_ value: Data?, forKey: String) {
    if value == nil {
      try? removeObject(forKey: forKey)
    } else {
      try? setObject(value!, forKey: forKey)
    }
  }

  func getData(forKey: String) -> Data? {
    guard canAccessKeychain() else {
      return nil
    }
    return try? object(forKey: forKey)
  }
}
