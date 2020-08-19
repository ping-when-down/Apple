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
    NavigationView {
      List {
        ForEach(pingWhenDownAPI.websites) { data in
          NavigationLink(destination: WebsiteDetail(website: data)) {
            ListRow(website: data)
          }
        }
        .onDelete(perform: delete)
        .onMove(perform: move)
      }
      .navigationBarTitle("Ping When Down")
      .navigationBarItems(leading: EditButton(), trailing: AddWebsiteButton().environmentObject(self.pingWhenDownAPI))
      .onAppear() {
        self.pingWhenDownAPI.set(state: .active)
        UITableView.appearance().separatorColor = .clear
      }
      .onDisappear() {
        self.pingWhenDownAPI.set(state: .paused)
      }
    }
  }
  
  func delete(at offsets: IndexSet) {
    pingWhenDownAPI.delete(at: offsets)
  }
  
  func move(from source: IndexSet, to destination: Int) {
    pingWhenDownAPI.reorder(from: source, to: destination)
  }
  
}
