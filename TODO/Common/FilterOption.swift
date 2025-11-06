//
//  FilterOption.swift
//  TODO
//
//  Created by 오정석 on 5/11/2025.
//

import Foundation

enum FilterOption: String, CaseIterable {  // ViewModel 내부에 정의
    case all = "전체"
    case active = "진행중"
    case completed = "완료"
}
