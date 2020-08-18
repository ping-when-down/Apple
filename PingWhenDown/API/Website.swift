//
//  Website.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import Foundation

struct Website: Codable, Identifiable, Equatable {
  let id = UUID()
  let title: String
  let url: String
  let interval: Int
  let statusCode: Int?
  let statusMessage: String?
  let responseTime: Int?
  let lastChecked: String?
  
  init(title: String, url: String, interval: Int) {
    self.title = title
    self.url = url
    self.interval = interval
    self.statusCode = nil
    self.statusMessage = nil
    self.responseTime = nil
    self.lastChecked = nil
  }
  
}
