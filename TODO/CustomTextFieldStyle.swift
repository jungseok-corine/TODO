//
//  CustomTextFieldStyle.swift
//  TODO
//
//  Created by 오정석 on 1/11/2025.
//

import SwiftUI


struct CustomTextFieldStyle: TextFieldStyle {
    let isValid: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isValid ? Color.clear : Color.red, lineWidth: 1)
            }
    }
}
