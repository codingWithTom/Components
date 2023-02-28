//
//  CalendarScene.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-08.
//

import SwiftUI

enum DateType {
  case calendar
  case datPicker
}

struct CalendarScene: View {
  @State private var selectedIdentifier: Calendar.Identifier = .gregorian
  @State private var selectedDate: Date?
  @State private var selectedDateFromPicker = Date()
  @State private var selectedDateComponents = Set<DateComponents>()
  @State private var selectedDateType: DateType = .datPicker
  
  private var textDate: String {
    guard let selectedDate else { return "Date not selected" }
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: selectedDate)
  }
  
  var dateInterval: ClosedRange<Date> {
    let calendar = Calendar(identifier: selectedIdentifier)
    guard
      let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.month, .year], from: Date())),
      let firstDayOfNextMonth = calendar.date(byAdding: .month, value: 3, to: firstDayOfMonth),
      let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfNextMonth)
    else { return Date() ... Date() }
    return firstDayOfMonth ... lastDayOfMonth
  }
  
  var dateRange: Range<Date> {
    let calendar = Calendar(identifier: selectedIdentifier)
    guard
      let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.month, .year], from: Date())),
      let firstDayOfNextMonth = calendar.date(byAdding: .month, value: 3, to: firstDayOfMonth),
      let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfNextMonth)
    else { return Range<Date>(uncheckedBounds: (lower: Date(), upper: Date())) }
    return Range<Date>(uncheckedBounds: (lower: firstDayOfMonth, upper: lastDayOfMonth))
  }
  
  var body: some View {
    VStack {
      Picker("", selection: $selectedDateType) {
        Text("Calendar")
          .tag(DateType.calendar)
        Text("Date Picker")
          .tag(DateType.datPicker)
      }
      switch selectedDateType {
      case .calendar:
        calendars
      case.datPicker:
        datePickers
      }
      Spacer()
    }
    .padding(.horizontal)
  }
  
  private var dates: String {
    guard !selectedDateComponents.isEmpty else { return "Dates not selected"}
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return selectedDateComponents.map { components in
      guard let date = components.date else { return nil}
      return formatter.string(from: date)
    }.compactMap { $0 }
      .joined(separator: "\t")
  }
  
  private var datePickers: some View {
    VStack {
      Text("Date Pickers Go Here!")
        .font(.title)
      Text(selectedDateFromPicker, format: .dateTime)
      DatePicker("Date Picker", selection: $selectedDateFromPicker, in: dateInterval, displayedComponents: .date)
      Text(dates)
      calendarIdentifiers
      MultiDatePicker("Multi Date Picker",
                      selection: $selectedDateComponents,
                      in: dateRange)
      .environment(\.calendar, .init(identifier: selectedIdentifier))
    }
  }
  
  private var calendars: some View {
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
        calendarIdentifiers
        CalendarView(calendarIdentifier: selectedIdentifier,
                     selectedDate: $selectedDate)
          .scaledToFit()
      }
    }
  }
  
  private var calendarIdentifiers: some View {
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
  }
}

struct CalendarScene_Previews: PreviewProvider {
  static var previews: some View {
    CalendarScene()
  }
}
