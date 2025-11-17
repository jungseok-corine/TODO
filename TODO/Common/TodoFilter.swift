//
//  TodoFilter.swift
//  TODO
//
//  Created by 오정석 on 5/11/2025.
//

import Foundation

enum TodoFilter: String, CaseIterable {
    case all
    case active
    case completed
    case highPriority
    case today
    case thisWeek
}
