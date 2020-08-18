//
//  LoadingIcon.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct LoadingIcon: View {
  
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @State var play = true
  
  var body: some View {
    LottieView(
      name: colorScheme == .dark ? "circular-loader-white" : "circular-loader-green",
      loopMode: .loop,
      duration: 1,
      play: $play
    )
  }
}
