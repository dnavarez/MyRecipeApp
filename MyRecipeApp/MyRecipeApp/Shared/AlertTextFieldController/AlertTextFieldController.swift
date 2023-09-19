//
//  AlertController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

final class AlertTextFieldController {
  func showAlert(
    on vc: UIViewController,
    title: String,
    textFieldPlaceHolder:[String],
    completion: @escaping ([String?]) -> Void
  ) {
    let alertController = UIAlertController(
      title: title,
      message: nil,
      preferredStyle: .alert
    )
    
    for (idx, placeholderText) in textFieldPlaceHolder.enumerated() {
      alertController.addTextField()
      if let tf = alertController.textFields?[idx] {
        tf.placeholder = placeholderText
      }
    }
    
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .default)
    
    let acceptAction = UIAlertAction(title: "Accept", style: .default) { _ in
      guard let textFields = alertController.textFields else { return completion([])}
      let values = textFields.map({ $0.text })
      completion(values)
    }
    
    alertController.addAction(cancelAction)
    alertController.addAction(acceptAction)
    
    vc.present(alertController, animated: true)
  }
}
