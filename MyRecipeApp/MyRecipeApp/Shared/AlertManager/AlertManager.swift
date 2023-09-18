//
//  AlertManager.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/18/23.
//

import UIKit

final class AlertManager {
  /// Show basic pop-up message
  private static func showBasicAlert(
    on vc: UIViewController,
    title: String,
    message: String?
  ) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
      let dismissAction =  UIAlertAction(title: "Dismiss", style: .default)
      alert.addAction(dismissAction)
      
      vc.present(alert, animated: true)
    }
  }
}

extension AlertManager {
  /// Show  alert for api call with error response
  public static func showAlert(
    on vc: UIViewController,
    title: String,
    error: ValidationError
  ) {
    showBasicAlert(on: vc, title: title, message: error.errorDescription)
  }
  
  /// Show basic alert
  public static func showAlertError(
    on vc: UIViewController,
    title: String,
    message: String?
  ) {
    showBasicAlert(on: vc, title: title, message: message)
  }
}
