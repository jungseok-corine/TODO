//
//  Extension.swift
//  TODO
//
//  Created by 오정석 on 11/11/2025.
//

import CoreData
import SwiftUI

extension TodoEntity {
    @NSManaged public var sectionDate: String?
}

extension DateFormatter {
    static let sectionDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let sectionTitle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()
}
