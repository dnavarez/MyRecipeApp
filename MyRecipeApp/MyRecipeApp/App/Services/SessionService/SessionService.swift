//
//  SessionService.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation
import FirebaseAuth
import Valet

protocol SessionServiceProtocol {
  var isActive: Bool { get }
  var currentUser: User? { get }
  
  func clearSession()
}

final class SessionService: SessionServiceProtocol {
  let valet: Valet
  
  init(valet: Valet) {
    self.valet = valet
  }
}

extension SessionService {
  var isActive: Bool {
    currentUser != nil
  }
  
  var currentUser: User? {
    Auth.auth().currentUser
  }
  
  func clearSession() {
    try? Auth.auth().signOut()
  }
}
