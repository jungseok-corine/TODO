//
//  SignUpView.swift
//  TODO
//
//  Created by 오정석 on 2/11/2025.
//

import SwiftUI

struct SignUpView: View {
    
    // MARK: -  PROPERTY
    @State private var viewModel = SignUpViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // MARK: -  BODY
    var body: some View {
        NavigationStack {
            Form {
                Section("기본 정보") {
                    TextField("이름", text: $viewModel.name)
                    TextField("이메일", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
                
                Section("비밀번호") {
                    SecureField("비밀번호", text: $viewModel.password)
                    SecureField("비밀번호 확인", text: $viewModel.confirmPassword)
                }
                
                Section {
                    Toggle("이용약관 동의", isOn: $viewModel.agreedToTerms)
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Section {
                        Text(viewModel.errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
                
                Section {
                    Button {
                        viewModel.signUp()
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("가입하기")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(viewModel.isLoading)
                }
            } //:FORM
            .navigationTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
            .alert("회원가입 성공", isPresented: $viewModel.signUpSuccess) {
                Button("확인") {
                    dismiss()
                }
            } message: {
                Text("로그인 화면으로 돌아갑니다")
            }
        } //:NAVIGATION
    }    
}

// MARK: -  PREVIEW
#Preview {
    SignUpView()
}
