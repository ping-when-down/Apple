//
//  APIStatus.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct APIState: View {
  
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  
  var state: PingWhenDownAPI.State
  
  var body: some View {
    VStack {
      getView()
    }
    .frame(width: 15, height: 15)
  }
  
  func getView() -> AnyView {
    switch state {
      case .error:
        return AnyView(ErrorIcon())
      case .loading:
        return AnyView(LoadingIcon())
      default:
        return AnyView(ActiveIcon())
    }
  }

}
