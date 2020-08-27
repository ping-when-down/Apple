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
  @State var https: Int = 1
  @State var host: String = ""
  @State var active: Bool = true
  
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
        
        Section(header: Text("HOST")) {
          Picker(
            selection: $https,
            label: Text("Protocol"),
            content: {
                  Text("HTTP").tag(0)
                  Text("HTTPS").tag(1)
          }).pickerStyle(SegmentedPickerStyle())
          
          TextField("my.website.com", text: $host)
            .textContentType(.URL)
            .keyboardType(.URL)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        
        Section(header: Text("SETTINGS")) {
          Toggle(isOn: $active) {
            Text("Enabled")
          }
        }
        
        Section {
          Button(action: {
            self.pingWhenDownAPI.add(website: Website(
              title: self.title,
              active: self.active,
              index: self.pingWhenDownAPI.websites.count,
              https: (self.https > 0) ? true : false,
              host: self.host
            ))
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
          self.pingWhenDownAPI.add(website: Website(
            title: self.title,
            active: self.active,
            index: self.pingWhenDownAPI.websites.count,
            https: (self.https > 0) ? true : false,
            host: self.host
          ))
          self.showAddWebsiteSheet = false
        }) {
          Text("Add")
      })
      
    }
  }
}
