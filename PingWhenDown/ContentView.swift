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
  
  @State var showAddWebsiteSheet = false
  
  var body: some View {
    
    NavigationView {
      WebsitesList(pingWhenDownAPI: pingWhenDownAPI)
        .navigationBarTitle("Ping When Down")
        .navigationBarItems(
          leading:
            EditButton(),
          trailing:
            Button(action: {
              self.showAddWebsiteSheet = true
            }) {
              Image(systemName: "plus")
            }
            .sheet(isPresented: $showAddWebsiteSheet) {
              AddWebsiteSheet(showAddWebsiteSheet: self.$showAddWebsiteSheet)
            }
        )
    }
    
  }
  
}
