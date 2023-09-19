//
//  AddInstructionController.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit

class AddInstructionController: UIViewController {
  
  // MARK: - IBOutlet
  @IBOutlet weak var textView: UITextView!
  
  // MARK: - Properties
  var onAccept: ((String) -> Void)?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setups()
  }
}

// MARK: - Setups
private extension AddInstructionController {
  func setups() {
    setupNavigationBar()
    
    textView.becomeFirstResponder()
  }
  
  func setupNavigationBar() {
    navigationItem.title = "Add Instructions"
    
    let cancelBtn = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancel))
    navigationItem.leftBarButtonItem = cancelBtn
    
    let acceptBtn = UIBarButtonItem(title: "Accept", style: .done, target: self, action: #selector(didTapAccept))
    navigationItem.rightBarButtonItem = acceptBtn
  }
}

// MARK: - Events
private extension AddInstructionController {
  @objc
  func didTapCancel() {
    navigationController?.dismiss(animated: true)
  }
  
  @objc
  func didTapAccept() {
    onAccept?(textView.text)
    navigationController?.dismiss(animated: true)
  }
}
