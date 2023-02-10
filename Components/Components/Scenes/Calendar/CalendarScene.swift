//
//  CalendarScene.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-08.
//

import SwiftUI

struct CalendarScene: View {
  @State private var selectedIdentifier: Calendar.Identifier = .gregorian
  @State private var selectedDate: Date?
  
  private var textDate: String {
    guard let selectedDate else { return "Date not selected" }
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: selectedDate)
  }
  
  var body: some View {
    ScrollView {
      VStack {
        Text("Calendars Go Here!")
          .font(.title)
        Text(textDate)
          .font(.title3)
        Spacer()
        CalendarView(canSelect: true,
                     selectedDate: $selectedDate)
          .scaledToFit()
        Spacer()
        Picker("", selection: $selectedIdentifier) {
          Text("Gregorian")
            .tag(Calendar.Identifier.gregorian)
          Text("Hebrew")
            .tag(Calendar.Identifier.hebrew)
          Text("Chinese")
            .tag(Calendar.Identifier.chinese)
          Text("Buddhist")
            .tag(Calendar.Identifier.buddhist)
          Text("Coptic")
            .tag(Calendar.Identifier.coptic)
          Text("Indian")
            .tag(Calendar.Identifier.indian)
          Text("Islamic")
            .tag(Calendar.Identifier.islamic)
        }
        CalendarView(calendarIdentifier: selectedIdentifier,
                     selectedDate: $selectedDate)
          .scaledToFit()
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
