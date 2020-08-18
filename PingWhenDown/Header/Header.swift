//
//  Header.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct Header: View {
  
  @ObservedObject var pingWhenDownAPI: PingWhenDownAPI

  var body: some View {
    
    VStack {
      ZStack {
        HStack {
//          APIState(state: pingWhenDownAPI.state)
          Button(action: {}) {
            Text("Edit")
          }
          Spacer()
          AddWebsiteButton()
        }
        Text("Ping When Down")
          .font(.system(size: 20))
          .bold()
      }
      .padding()
      Divider()
    }
    
  }
  
}
