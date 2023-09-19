//
//  AppDelegate+Style.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

extension AppDelegate  {
  func applyAppStyle() {
    applyNavigationStyle()
  }

  func applyNavigationStyle() {
    let attrs = [
        NSAttributedString.Key.foregroundColor: UIColor.systemGreen,
        NSAttributedString.Key.font: UIFont(name: "Noteworthy-Light", size: 24)!
    ]

    UINavigationBar.appearance().titleTextAttributes = attrs
  }
}

