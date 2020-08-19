//
//  AddWebsiteButton.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct AddWebsiteButton: View {
  
  @EnvironmentObject var pingWhenDownAPI: PingWhenDownAPI
  
  @State var showAddWebsiteSheet = false
  
  var body: some View {
    Button(action: {
      self.showAddWebsiteSheet = true
    }) {
      Image(systemName: "plus")
    }
    .sheet(isPresented: $showAddWebsiteSheet) {
      AddWebsiteSheet(showAddWebsiteSheet: self.$showAddWebsiteSheet)
        .environmentObject(self.pingWhenDownAPI)
    }
  }
  
}

