//
//  CalendarView.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-09.
//

import SwiftUI

struct CalendarView: UIViewRepresentable {
  @Binding var selectedDates: [Date]
  
  func makeCoordinator() -> CalendarCoordinator {
    CalendarCoordinator(
      selectedDates: $selectedDates
    )
  }
  
  func makeUIView(context: Context) -> UICalendarView {
    let view = UICalendarView()
    view.selectionBehavior =
    UICalendarSelectionMultiDate(
      delegate: context.coordinator)
    return view
  }
  
  func updateUIView(_ uiView: UICalendarView, context: Context) {
    
  }
}

final class CalendarCoordinator:
  NSObject,
  UICalendarSelectionMultiDateDelegate
{
  @Binding var selectedDates: [Date]
  
  init(selectedDates: Binding<[Date]>) {
    self._selectedDates = selectedDates
  }
  
  func multiDateSelection(
    _ selection: UICalendarSelectionMultiDate,
    didSelectDate dateComponents: DateComponents)
  {
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)
    guard let date else { return }
    selectedDates.append(date)
  }
  
  func multiDateSelection(
    _ selection: UICalendarSelectionMultiDate,
    didDeselectDate dateComponents: DateComponents)
  {
    let calendar = Calendar.current
    let date = calendar.date(from: dateComponents)
    guard let date else { return }
    let index = selectedDates.firstIndex(
      where: { $0 == date}
    )
    guard let index else { return }
    selectedDates.remove(at: index)
  }
}
