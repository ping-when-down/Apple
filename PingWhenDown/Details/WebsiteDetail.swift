//
//  WebsiteDetail.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct WebsiteDetail: View {
  
  let website: Website
  
  var body: some View {
    Text(website.properties.title)
  }
  
}
