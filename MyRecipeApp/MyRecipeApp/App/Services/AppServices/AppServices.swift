//
//  AppServices.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import Foundation

import Valet

protocol AppServicesProtocol {
  var sessionService: SessionServiceProtocol { get }
  var authService: AuthServiceProtocol { get }
}

final class AppServices: AppServicesProtocol {
  static let shared = AppServices()
  
  var sessionService: SessionServiceProtocol
  var authService: AuthServiceProtocol
  
  let valet = Valet.valet(
    with: Identifier(nonEmpty: Bundle.main.bundleIdentifier!)!,
    accessibility: .whenUnlocked
  )
  
  // We should be passing the app config to use if we have multiple environment (staging, production)
  init() {
    sessionService = SessionService(valet: valet)
    authService = AuthService()
  }
}
