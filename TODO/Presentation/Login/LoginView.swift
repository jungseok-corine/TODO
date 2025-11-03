//
//  LoginView.swift
//  TODO
//
//  Created by 오정석 on 1/11/2025.
//

import SwiftUI

struct LoginView: View {
    
    // MARK: -  PROPERTY
    @State private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    // MARK: -  BODY
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 로고 영역
                    VStack(spacing: 8) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.blue)
                        
                        Text("Welcome Back")
                            .font(.title)
                            .bold()
                        
                        Text("로그인하여 계속하세요")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } //:VSTACK - 로고 영역
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // 입력 폼
                    VStack(spacing: 16) {
                        // 이메일 입력
                        VStack(alignment: .leading, spacing: 8) {
                            Text("이메일")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            TextField("email@example.com", text: $viewModel.email)
                                .textFieldStyle(CustomTextFieldStyle(
                                    isValid: viewModel.isEmailValid || viewModel.email.isEmpty
                                ))
                                .textContentType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .keyboardType(.emailAddress)
                                .focused($focusedField, equals: .email)
                                .onChange(of: viewModel.email) {
                                    viewModel.validateEmail()
                                }
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .password
                                }
                            
                            if !viewModel.email.isEmpty && !viewModel.isEmailValid {
                                Text("올바른 이메일 형식이 아닙니다")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        } //:VSTACK - 이메일 입력
                        
                        // 비밀번호 입력
                        VStack(alignment: .leading, spacing:8) {
                            Text("비밀번호")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            
                            SecureField("최소 6자 이상", text: $viewModel.password)
                                .textFieldStyle(CustomTextFieldStyle(
                                    isValid: viewModel.isPasswordValid || viewModel.password.isEmpty
                                ))
                                .textContentType(.password)
                                .focused($focusedField, equals: .password)
                                .onChange(of: viewModel.password) {
                                    viewModel.validatePassword()
                                }
                                .submitLabel(.done)
                                .onSubmit {
                                    if viewModel.isFormValid {
                                        Task {
                                            await viewModel.login()
                                        }
                                    }
                                }
                            if !viewModel.password.isEmpty && !viewModel.isPasswordValid {
                                Text("비밀번호는 최소 6자 이상이어야 합니다")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        } //:VSTACK - 비밀번호 입력
                        
                        // 에러 메시지
                        if !viewModel.errorMessage.isEmpty {
                            Text(viewModel.errorMessage)
                                .font(.callout)
                                .foregroundStyle(.red)
                                .padding(.vertical, 8)
                        }
                    } //:VSTACK - 입력폼
                    .padding(.horizontal, 24)
                    
                    // 로그인 버튼
                    Button {
                        Task {
                            await viewModel.login()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        } else {
                            Text("로그인")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                    }
                    .background(viewModel.isFormValid ? Color.blue : Color.gray)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                    
                    // 추가 옵션
                    HStack {
                        Button("비밀번호 찾기") {
                            // TODO
                        }
                        .font(.subheadline)
                        
                        Spacer()
                        
                        NavigationLink("회원가입") {
                            SignUpView() // 해당 부분 NavigationPath에 추가해야함
                        }
                        .font(.subheadline)
                    } //:HSTACK - 추가 옵션
                    .padding(.horizontal, 24)
                    
                    Spacer()
                } //:VSTACK
            } //:SCROLL
            .navigationBarTitleDisplayMode(.inline)
        } //:NAVIGATION
    }
}

// MARK: -  PREVIEW
#Preview {
    LoginView()
}
