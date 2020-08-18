//
//  ErrorIcon.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct ErrorIcon: View {
  
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @State var play = true
  
  var body: some View {
    LottieView(
      name: "estimated-icon",
      loopMode: .loop,
      aspect: .scaleAspectFit,
      play: $play
    )
  }
}
