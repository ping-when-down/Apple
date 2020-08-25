//
//  Website.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import Foundation

struct WebsiteModel: Codable, Identifiable, Equatable {
  let id = UUID()
  var _id: String?
  var title: String
  var active: Bool
  var index: Int
  var https: Bool
  var host: String
  var interval: Int
  var statusCode: Int?
  var statusMessage: String?
  var responseTime: Int?
  var lastChecked: String?
  var lastDown: String?
  
  init(title: String, active: Bool, index: Int, https: Bool, host: String, interval: Int) {
    self._id = nil
    self.title = title
    self.active = active
    self.index = index
    self.https = https
    self.host = host
    self.interval = interval
    self.statusCode = nil
    self.statusMessage = nil
    self.responseTime = nil
    self.lastChecked = nil
    self.lastDown = nil
  }
  
  init() {
    self._id = nil
    self.title = ""
    self.active = true
    self.index = 0
    self.https = true
    self.host = ""
    self.interval = 999
    self.statusCode = nil
    self.statusMessage = nil
    self.responseTime = nil
    self.lastChecked = nil
    self.lastDown = nil
  }
  
}
