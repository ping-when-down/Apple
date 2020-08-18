//
//  ActiveIcon.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import SwiftUI

struct ActiveIcon: View {
  
  @Environment(\.colorScheme) var colorScheme: ColorScheme
  @State var play = true
  
  var body: some View {
    LottieView(
      name: "live-icon",
      loopMode: .loop,
      aspect: .scaleAspectFit,
      play: $play
    )
  }
}
