//
//  SignUpViewModel.swift
//  TODO
//
//  Created by 오정석 on 2/11/2025.
//

import Foundation


@Observable
class SignUpViewModel {
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    var agreedToTerms = false
    var errorMessage = ""
    var isLoading = false
    var signUpSuccess = false
    
    func signUp() {
        // 유효성 검사
        guard !name.isEmpty else {
            errorMessage = "이름을 입력하세요"
            return
        }
        
        guard validateEmail() else {
            errorMessage = "올바른 이메일을 입력하세요"
            return
        }
        
        guard password.count >= 6 else {
            errorMessage = "비밀번호는 6자 이상이어야 합니다"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "비밀번호가 일치하지 않습니다"
            return
        }
        
        guard agreedToTerms else {
            errorMessage = "약관에 동의해주세요"
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        
        // 가짜 회원가입
        Task {
            try? await Task.sleep(for: .seconds(2))
            
            await MainActor.run {
                isLoading = false
                signUpSuccess = true
            }
        }
    }
    
    private func validateEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
}
