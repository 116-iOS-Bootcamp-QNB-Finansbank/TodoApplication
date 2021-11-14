//
//  UImageEnums.swift
//  TodoApp
//
//  Created by alican on 13.11.2021.
//

import Foundation

enum ImageName : CustomStringConvertible {
  case circle
  case moon
  case checkmark
  case xmark
  
  var description : String {
    switch self {
    case .circle: return "circle.inset.filled"
    case .moon: return "moon"
    case .checkmark: return "checkmark.seal.fill"
    case .xmark: return "xmark.seal.fill"
    }
  }
}


