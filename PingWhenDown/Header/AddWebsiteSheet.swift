//
//  AddWebsiteSheet.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct AddWebsiteSheet: View {
  
  @Binding var showAddWebsiteSheet: Bool
  
  @State var title: String = ""
  @State var url: String = ""
  
  @State var enabled: Bool = true
  @State private var intervalIndex = 0
  var intervalOptions = [10, 30, 60, 300]
  
  let pingWhenDownAPI = PingWhenDownAPI()
  
  var body: some View {
    NavigationView {
      
      Form {
        
        Section(header: Text("TITLE")) {
          TextField("Website Title", text: $title)
        }
        
        Section(header: Text("URL")) {
          TextField("https://my.website.com", text: $url)
        }
        
        Section(header: Text("SETTINGS")) {
          Toggle(isOn: $enabled) {
            Text("Enabled")
          }
          Picker(selection: $intervalIndex, label: Text("Monitor Interval")) {
            ForEach(0 ..< intervalOptions.count) {
              Text(String(self.intervalOptions[$0]))
            }
          }
        }
        
        Section {
          Button(action: {
            self.pingWhenDownAPI.addWebsite(data: Website(title: self.title, url: self.url, interval: self.intervalOptions[self.intervalIndex]) )
            self.showAddWebsiteSheet = false
          }) {
            Text("Add Website")
          }
        }
        
        Section {
          Button(action: {
            self.showAddWebsiteSheet = false
          }) {
            Text("Cancel")
              .foregroundColor(Color(.systemRed))
          }
        }
        
      }
      .navigationBarTitle("Add Website")
      .navigationBarItems(
        leading: Button(action: {
          self.showAddWebsiteSheet = false
        }) {
          Text("Cancel")
            .foregroundColor(Color(.systemRed))
        },
        trailing: Button(action: {
          self.pingWhenDownAPI.addWebsite(data: Website(title: self.title, url: self.url, interval: self.intervalOptions[self.intervalIndex]) )
          self.showAddWebsiteSheet = false
        }) {
          Text("Add")
      })
      
    }
  }
}
