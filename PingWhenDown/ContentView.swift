//
//  ContentView.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 16/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  var body: some View {
    
    VStack {
      Text("Hello, World!")
      List {
        ListRow(website: Website(title: "Earth", url: "https://joao.earth", interval: 1, statusCode: 200, statusMessage: "OK", responseTime: 356, lastChecked: nil))
        ListRow(website: Website(title: "Earth", url: "https://joao.earth", interval: 1, statusCode: 500, statusMessage: "OK", responseTime: 356, lastChecked: nil))
        ListRow(website: Website(title: "Earth", url: "https://joao.earth", interval: 1, statusCode: nil, statusMessage: "OK", responseTime: 356, lastChecked: nil))
      }
    }
    
  }
}


