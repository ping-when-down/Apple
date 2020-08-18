//
//  ContentView.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 16/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct ContentView: View {
  
  @ObservedObject var pingWhenDownAPI = PingWhenDownAPI()
  
  var body: some View {
    
    VStack {
      Header(pingWhenDownAPI: pingWhenDownAPI)
      WebsitesList(pingWhenDownAPI: pingWhenDownAPI)
        .padding(.top, -7)
    }
    
  }
  
}


