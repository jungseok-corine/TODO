//
//  Extension.swift
//  TODO
//
//  Created by 오정석 on 11/11/2025.
//

import Combine

// Combine → async/await 헬퍼
extension Publisher {
    func asyncValue() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var hasResumed = false
            
            cancellable = first()
                .sink(
                    receiveCompletion: { completion in
                        guard !hasResumed else { return }
                        hasResumed = true
                        
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                        cancellable?.cancel()
                    },
                    receiveValue: { value in
                        guard !hasResumed else { return }
                        hasResumed = true
                        continuation.resume(returning: value)
                        cancellable?.cancel()
                    }
                )
        }
    }
}
