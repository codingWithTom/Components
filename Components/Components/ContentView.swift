//
//  ContentView.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-08.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      CalendarScene()
        .tabItem {
          Label("Calendar", systemImage: "calendar")
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
