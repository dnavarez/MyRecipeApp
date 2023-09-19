//
//  UITableView+Utils.swift
//  MyRecipeApp
//
//  Created by Dan Navarez on 9/19/23.
//

import UIKit
import RswiftResources

extension UITableView {
  func registerCells(nibs: [any NibReferenceContainer]) {
    nibs.forEach({ register(UINib(resource: $0), forCellReuseIdentifier: $0.name) })
  }
}
