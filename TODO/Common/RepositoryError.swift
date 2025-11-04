//
//  RepositoryError.swift
//  TODO
//
//  Created by 오정석 on 4/11/2025.
//

import Foundation

/// Repository 에러 타입
enum RepositoryError: Error, LocalizedError {
    case notFound
    case saveFailed
    case deleteFailed
    case decodeFailed
    case encodeFailed
    
    var errorDescription: String? {
        switch self {
        case .notFound: return "할 일을 찾을 수 없습니다"
        case .saveFailed: return "저장에 실패했습니다"
        case .deleteFailed: return "삭제에 실패했습니다"
        case .decodeFailed: return "데이터 읽기에 실패했습니다"
        case .encodeFailed: return "데이터 변환에 실패했습니다"
        }
    }
}
