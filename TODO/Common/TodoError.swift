//
//  TodoError.swift
//  TODO
//
//  Created by 오정석 on 3/11/2025.
//

import Foundation

enum TodoError: Error, LocalizedError {
    case emptyTitle
    case notFound
    case saveFailed
    case deleteFailed
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle: return "제목을 입력해주세요"
        case .notFound: return "할 일을 찾을 수 없습니다"
        case .saveFailed: return "저장에 실패했습니다"
        case .deleteFailed: return "삭제에 실패했습니다"
        }
    }
}
