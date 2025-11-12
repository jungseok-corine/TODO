//
//  PriorityBadge.swift
//  TODO
//
//  Created by 오정석 on 5/11/2025.
//

import SwiftUI

struct PriorityBadge: View {
    let priority: Int
    
    private var priorityText: String {
        switch priority {
        case 2: return "높음"
        case 1: return "보통"
        default: return "낮음"
        }
    }
    
    private var priorityColor: Color {
        switch priority {
        case 2: return .red
        case 1: return .orange
        default: return .blue
        }
    }
    
    var body: some View {
        Text(priorityText)
            .font(.caption2)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(priorityColor.opacity(0.2))
            .foregroundStyle(priorityColor)
            .cornerRadius(4)
    }
}

#Preview {
    PriorityBadge(priority: 0)
}
