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
    case fetchFailed
    case saveFailed
    case deleteFailed
    case updateFailed
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle: return "제목을 입력해주세요"
        case .notFound: return "할 일을 찾을 수 없습니다"
        case .fetchFailed: return "할 일 목록을 불러올 수 없습니다"
        case .saveFailed: return "저장에 실패했습니다"
        case .deleteFailed: return "삭제에 실패했습니다"
        case .updateFailed: return "할 일 수정에 실패했습니다"
        }
    }
}
