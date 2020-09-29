//
//  Data.swift
//  ApiVkEx
//
//  Created by Егор on 22.09.2020.
//  Copyright © 2020 Stroev Egor. All rights reserved.
//

import Foundation

extension Data {
  
  var jsonDictionary: [String:Any]? {
      guard self.count > 0 else { return [String:Any]() }
      do {
          return try JSONSerialization.jsonObject(with: self ) as? [String:Any]
      } catch {
          return nil
      }
    }
}
