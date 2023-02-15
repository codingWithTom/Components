//
//  CalendarScene.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-08.
//

import SwiftUI

struct CalendarScene: View {
  @State
  private var selectedDates: [Date] = []
  
  private var textDate: String {
    guard !selectedDates.isEmpty
    else { return "Date not selected" }
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    let texts = selectedDates.map {
      formatter.string(from: $0)
    }
    return String(
      texts.joined(separator: "\n")
    )
  }
  
  var body: some View {
    ScrollView {
      VStack {
        Text("Calendars Go Here!")
          .font(.title)
        Text(textDate)
          .font(.title3)
        Spacer()
        CalendarView(
          selectedDates: $selectedDates
        )
          .scaledToFit()
        Spacer()
      }
    }
    .padding(.horizontal)
  }
}

struct CalendarScene_Previews: PreviewProvider {
  static var previews: some View {
    CalendarScene()
  }
}
