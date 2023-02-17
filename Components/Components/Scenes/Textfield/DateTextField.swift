//
//  DateTextField.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-16.
//

import SwiftUI

struct DateTextField: UIViewRepresentable {
  @Binding var date: Date?
  
  func makeCoordinator() -> DateTextFieldCoordinator {
    return DateTextFieldCoordinator(date: $date)
  }
  
  func makeUIView(context: Context) -> UITextField {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    textField.delegate = context.coordinator
    textField.placeholder = "MM/DD/YYYY"
    return textField
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    
  }
}

final class DateTextFieldCoordinator: NSObject, UITextFieldDelegate {
  @Binding var date: Date?
  private var dateString: String = ""
  private let placeholder = "MM/DD/YYYY"
  private let formatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMddyyyy"
    return dateFormatter
  }()
  
  init(date: Binding<Date?>) {
    self._date = date
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn
                 range: NSRange, replacementString string: String) -> Bool {
    if string == "", !dateString.isEmpty {
      dateString.remove(at: dateString.index(before: dateString.endIndex))
    } else if dateString.count < 8 {
      dateString += string
    }
    let filledDate = formatFilledDate(dateString)
    let startIndexPlaceholer = placeholder.index(placeholder.startIndex, offsetBy: filledDate.count)
    let remainingPlaceholder = String(placeholder[startIndexPlaceholer ..< placeholder.endIndex])
    date = formatter.date(from: dateString)
    var attributtedString = AttributedString(filledDate + remainingPlaceholder)
    if let rangeOfFilled = attributtedString.range(of: filledDate) {
      attributtedString[rangeOfFilled].foregroundColor = date != nil ? UIColor.green : UIColor.black
    }
    if let rangeOfPlaceholder = attributtedString.range(of: remainingPlaceholder) {
      attributtedString[rangeOfPlaceholder].foregroundColor = UIColor.lightGray
    }
    textField.attributedText = NSAttributedString(attributtedString)
    
    let distance = filledDate.count
    if let position = textField.position(from: textField.beginningOfDocument, offset: distance) {
      textField.selectedTextRange = textField.textRange(from: position, to: position)
    }
    return false
  }
  
  private func formatFilledDate(_ date: String) -> String {
    var filledDate = date
    switch date.count {
    case 2,3:
      filledDate.insert("/", at: filledDate.index(filledDate.startIndex, offsetBy: 2))
    case 4 ... 8:
      filledDate.insert("/", at: filledDate.index(filledDate.startIndex, offsetBy: 2))
      filledDate.insert("/", at: filledDate.index(filledDate.startIndex, offsetBy: 5))
    default:
      break
    }
    return filledDate
  }
}
