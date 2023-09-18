//
//  ValidationError.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import Foundation

enum ValidationError: Error, Equatable {
  case emptyEmail
  case emptyPassword
  
  case invalidEmail
  case invalidPassword
  
  case other(message: String)
}

extension ValidationError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .emptyEmail:
      return NSLocalizedString("Email must not be empty!", comment: "")
    case .emptyPassword:
      return NSLocalizedString("Password must not be empty!", comment: "")
    case .invalidEmail:
      return NSLocalizedString("Email is Invalid!", comment: "")
    case .invalidPassword:
      return NSLocalizedString("Password is Invalid!", comment: "")
    case .other(let message):
      return NSLocalizedString(message, comment: "")
    }
  }
}
