//
//  RecipeModelTest.swift
//  MyRecipeAppTests
//
//  Created by Dan Navarez on 9/20/23.
//

import Foundation
import XCTest

@testable import MyRecipeApp

final class RecipeModelTest: XCTestCase {
  func testDecodeModel() {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      
//    if let recipeModel = try decoder.decode(RecipeModel.self, from: recipeData) {
//      XCTAssertNotNil(recipeModel)
//    }
    
    print(recipeData)
  }
}

extension RecipeModelTest {
  var recipeData: [String: Any] {
    [
      "id": "awdadasds",
      "title": "Choco macaroons",
      "ingredients": [
        [
          "name": "Flour",
          "quantity": "1kg"
        ],
        [
          "name": "Eggs",
          "quantity": "12 pcs"
        ]
      ],
      "instruction": "1. Mixed All\n2. Bake for 1 hour",
      "ownerId": "qqhuopuQnjQjwlrNfiVJWXZO0uK2"
    ]
  }
}

/*
  
  {
    "instruction" : "1. Mixed All\n2. Bake for 1 hour",
    "title" : "Choco macaroons",
    "ingredients" : [
      {
        "name" : "Flour",
        "quantity" : "1kg"
      },
      {
        "name" : "Eggs",
        "quantity" : "12 pcs"
      }
    ],
    "ownerId" : "qqhuopuQnjQjwlrNfiVJWXZO0uK2"
  }
  */
