//
//  ListStatusIcon.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct ListStatusIcon: View {
  
  let statusCode: Int?
  let statusMessage: String?
  
  var body: some View {
    
    let backgroundColor: Color
    let foregroundColor: Color
    
    switch statusCode {
      case 200:
        backgroundColor = Color(red: 0.85, green: 0.95, blue: 0.88)
        foregroundColor  = Color(red: 0.15, green: 0.65, blue: 0.25)
        break
      case 500:
        backgroundColor = Color(red: 0.93, green: 0.10, blue: 0.10)
        foregroundColor  = Color(.white)
        break
      default:
        backgroundColor = Color(red: 0.95, green: 0.95, blue: 0.95)
        foregroundColor  = Color(red: 0.65, green: 0.65, blue: 0.65)
        break
    }

    return ZStack {

      RoundedRectangle(cornerRadius: 10)
        .fill(backgroundColor)

      Text(statusCode != nil ? "\(statusCode!)" : "...")
        .font(.title)
        .bold()
        .foregroundColor(foregroundColor)

    }
    .frame(width: 80, height: 80)
    .padding(.trailing, 10)
  
  }
  
}
