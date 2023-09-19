//
//  AppDelegate.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  static var shared: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
  
  var window: UIWindow?
  var appServices: AppServicesProtocol!
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Do not configure firebase if we are running on unit test
    if !UIApplication.isRunningTests {
      FirebaseApp.configure()
    }
    
    let appServices = AppServices()
    self.appServices = appServices
    
    applyAppStyle()
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    updateRootViewController()
    self.window?.makeKeyAndVisible()
    
    return true
  }
}

