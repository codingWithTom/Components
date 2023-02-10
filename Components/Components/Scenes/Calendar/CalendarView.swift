//
//  CalendarView.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-09.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
  var calendarIdentifier: Calendar.Identifier = .gregorian
  var canSelect: Bool = false
  @Binding var selectedDate: Date?
  
  var dateInterval: DateInterval {
    let calendar = Calendar(identifier: calendarIdentifier)
    guard
      let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.month, .year], from: Date())),
      let firstDayOfNextMonth = calendar.date(byAdding: .month, value: 1, to: firstDayOfMonth),
      let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfNextMonth)
    else { return DateInterval() }
    return DateInterval(start: firstDayOfMonth, end: lastDayOfMonth)
  }
  
  func makeCoordinator() -> CalendarCoordinator {
    CalendarCoordinator(calendarIdentifier: calendarIdentifier, canSelect: canSelect, selectedDate: $selectedDate)
  }
  
  func makeUIView(context: Context) -> UICalendarView {
    let view = UICalendarView()
    view.availableDateRange = dateInterval
    view.calendar = Calendar(identifier: calendarIdentifier)
    if canSelect {
      view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
    }
    view.delegate = context.coordinator
    return view
  }
  
  func updateUIView(_ uiView: UICalendarView, context: Context) {
    let calendar = Calendar(identifier: calendarIdentifier)
    uiView.calendar = calendar
    uiView.availableDateRange = dateInterval
    context.coordinator.calendarIdentifier = calendarIdentifier
    if !canSelect, let selectedDate {
      var components = Set<DateComponents>()
      if let previousDate = context.coordinator.pickedDate {
        components.insert(calendar.dateComponents([.month, .day, .year], from: previousDate))
      }
      components.insert(calendar.dateComponents([.month, .day, .year], from: selectedDate))
      context.coordinator.pickedDate = selectedDate
      uiView.reloadDecorations(forDateComponents: Array(components), animated: true)
    }
  }
}

final class CalendarCoordinator: NSObject, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
  var calendarIdentifier: Calendar.Identifier
  let canSelect: Bool
  @Binding var selectedDate: Date?
  var pickedDate: Date?
  var calendar: Calendar {
    Calendar(identifier: calendarIdentifier)
  }
  
  init(calendarIdentifier: Calendar.Identifier, canSelect: Bool, selectedDate: Binding<Date?>) {
    self.calendarIdentifier = calendarIdentifier
    self.canSelect = canSelect
    self._selectedDate = selectedDate
  }
  
  func dateSelection(_ selection: UICalendarSelectionSingleDate,
                     canSelectDate dateComponents: DateComponents?) -> Bool {
    guard
      let dateComponents,
      let date = calendar.date(from: dateComponents)
    else { return false }
    return !calendar.isDateInWeekend(date)
  }
  
  func dateSelection(_ selection: UICalendarSelectionSingleDate,
                     didSelectDate dateComponents: DateComponents?) {
    guard
      let dateComponents,
      let date = calendar.date(from: dateComponents)
    else { return }
    self.selectedDate = date
  }
  
  func calendarView(_ calendarView: UICalendarView,
                    decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
    if canSelect {
      let valentinesDateComponents = DateComponents(calendar: calendar, year: 2023, month: 2, day: 14)
      guard
        let date = calendar.date(from: dateComponents),
        let valentinesDate = calendar.date(from: valentinesDateComponents)
      else { return nil }
      if calendar.isDate(date, equalTo: valentinesDate, toGranularity: .day) {
        return .image(UIImage(systemName: "heart.fill"), color: .red)
      } else if calendar.isDateInWeekend(date) {
        return .customView {
          let label = UILabel()
          label.text = "🐶🐈"
          return label
        }
      } else {
        return nil
      }
    } else {
      guard
        let date = calendar.date(from: dateComponents),
        let pickedDate,
        date == pickedDate
      else { return nil }
      return .default(color: .orange, size: .large)
    }
  }
}
