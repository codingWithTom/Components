//
//  TextfieldScene.swift
//  Components
//
//  Created by Tomas Trujillo on 2023-02-14.
//

import SwiftUI

struct TextfieldScene: View {
  @State private var cardNumber: String = ""
  @State private var date: Date?
  
  let formatter = NumberFormatter()
  var body: some View {
    VStack {
      Text("Textfields Go Here!")
        .font(.title)
      Text("Card number: \(cardNumber)")
      CreditCardNumberTextfield(text: $cardNumber)
      if let date {
        Text(date, format: .dateTime)
      } else {
        Text("No valid date added")
      }
      DateTextField(date: $date)
      Spacer()
    }
    .padding(.horizontal)
  }
}

struct TextfieldScene_Previews: PreviewProvider {
  static var previews: some View {
    TextfieldScene()
  }
}
