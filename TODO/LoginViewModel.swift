//
//  LoginViewModel.swift
//  TODO
//
//  Created by 오정석 on 1/11/2025.
//

import SwiftUI
import Observation

@Observable
class LoginViewModel {
    var email = ""
    var password = ""
    var isLoading = false
    var errorMessage = ""
    var isEmailValid = false
    var isPasswordValid = false
    
    var isFormValid: Bool {
        isEmailValid && isPasswordValid
    }
    
    func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        isEmailValid = emailPredicate.evaluate(with: email)
    }
    
    func validatePassword() {
        isPasswordValid = password.count >= 6
    }
    
    func login() async {
        isLoading = true
        errorMessage = ""
        
        // 간단한 로그인 시뮬레이션
        try? await Task.sleep(for: .seconds(2))
        
        if email == "test@test.com" && password == "123456" {
            print("로그인 성공!")
        } else {
            errorMessage = "이메일 또는 비밀번호가 올바르지 않습니다."
        }
        
        isLoading = false
    }
}
