//
//  UITextFieldExtension.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import UIKit

extension UITextField {
  /// This will add padding left and right
  func addPadding() {
    leftViewMode = .always
    leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: frame.size.height))
  }
}
