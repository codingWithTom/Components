//
//  CreditCardNumberTextfield.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-16.
//

import SwiftUI

struct CreditCardNumberTextfield: UIViewRepresentable {
  @Binding var text: String
  
  func makeCoordinator() -> CreditCardNumberTextfieldCoordinator {
    return CreditCardNumberTextfieldCoordinator(text: $text)
  }
  
  func makeUIView(context: Context) -> UITextField {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    textField.delegate = context.coordinator
    return textField
  }
  
  func updateUIView(_ uiView: UITextField, context: Context) {
    
  }
}

final class CreditCardNumberTextfieldCoordinator: NSObject, UITextFieldDelegate {
  @Binding var text: String
  private var cardNumber: String = ""
  private let formatter = CreditCardFormatter()
  
  init(text: Binding<String>) {
    self._text = text
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn
                 range: NSRange, replacementString string: String) -> Bool {
    if string == "", !cardNumber.isEmpty {
      cardNumber.remove(at: cardNumber.index(before: cardNumber.endIndex))
    } else if cardNumber.count < 16 {
      cardNumber += string
    }
    let formattedNumber = formatter.formatCardNumber(cardNumber)
    textField.text = formattedNumber
    if let indexOfLastDigit = formattedNumber.lastIndex(where: { $0 != " " }) {
      let distance = formattedNumber.distance(from: formattedNumber.startIndex, to: indexOfLastDigit) + 1
      if let position = textField.position(from: textField.beginningOfDocument, offset: distance) {
        textField.selectedTextRange = textField.textRange(from: position, to: position)
      }
    }
    text = cardNumber
    return false
  }
}

private final class CreditCardFormatter {
  func formatCardNumber(_ cardNumber: String) -> String {
    guard !cardNumber.isEmpty else { return cardNumber }
    var formattedString = ""
    for index in 1 ... cardNumber.count {
      let character = String(cardNumber[cardNumber.index(cardNumber.startIndex, offsetBy: index - 1)])
      formattedString += character
      if index % 4 == 0 {
        formattedString += " "
      }
    }
    return formattedString
  }
}
