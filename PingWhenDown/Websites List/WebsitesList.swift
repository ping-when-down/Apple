//
//  WebsitesList.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct WebsitesList: View {
  
  @ObservedObject var pingWhenDownAPI: PingWhenDownAPI
  
  var body: some View {
    List(pingWhenDownAPI.websites) { website in
      NavigationLink(destination: Text("Detail")) {
        ListRow(website: website)
      }
    }.onAppear() {
      self.pingWhenDownAPI.set(state: .active)
      UITableView.appearance().separatorColor = .clear
    }
    
  }


}
