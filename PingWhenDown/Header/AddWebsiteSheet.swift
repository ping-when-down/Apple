//
//  AddWebsiteSheet.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct AddWebsiteSheet: View {
  
  @EnvironmentObject var pingWhenDownAPI: PingWhenDownAPI
  
  @Binding var showAddWebsiteSheet: Bool
  
  @State var title: String = ""
  @State var url: String = ""
  @State var interval: String = ""
  
  @State var enabled: Bool = true
  
  var body: some View {
    
    UITableView.appearance().separatorColor = .separator
    UITextField.appearance().clearButtonMode = .whileEditing
    
    return NavigationView {
      
      Form {
        
        Section(header: Text("TITLE")) {
          TextField("Website Title", text: $title)
            .textContentType(.name)
            .autocapitalization(.words)
        }
        
        Section(header: Text("URL")) {
          TextField("https://my.website.com", text: $url)
            .textContentType(.URL)
            .keyboardType(.URL)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        
        Section(header: Text("INTERVAL")) {
          TextField("10 seconds", text: $interval)
            .keyboardType(.numberPad)
        }
        
        Section(header: Text("SETTINGS")) {
          Toggle(isOn: $enabled) {
            Text("Enabled")
          }
        }
        
        Section {
          Button(action: {
//            self.pingWhenDownAPI.add(website: Website(title: self.title, url: self.url, interval: Int(self.interval) ?? 30, index: self.pingWhenDownAPI.websites.count) )
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
//          self.pingWhenDownAPI.add(website: Website(title: self.title, url: self.url, interval: Int(self.interval) ?? 30, index: self.pingWhenDownAPI.websites.count) )
          self.showAddWebsiteSheet = false
        }) {
          Text("Add")
      })
      
    }
  }
}
