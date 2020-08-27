//
//  Website.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import Foundation
import Combine

struct Website: Codable, Identifiable, Equatable {
  
  let id = UUID()
  var _id: String?
  var title: String
  var active: Bool
  var index: Int
  var https: Bool
  var host: String
  var statusCode: Int?
  var statusMessage: String?
  var responseTime: Int?
  var lastChecked: String?
  var lastDown: String?
  
  init(title: String, active: Bool, index: Int, https: Bool, host: String) {
    self._id = nil
    self.title = title
    self.active = active
    self.index = index
    self.https = https
    self.host = host
    self.statusCode = nil
    self.statusMessage = nil
    self.responseTime = nil
    self.lastChecked = nil
    self.lastDown = nil
  }
  
}
