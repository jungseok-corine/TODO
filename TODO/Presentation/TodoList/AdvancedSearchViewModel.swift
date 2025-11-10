//
//  AdvancedSearchViewModel.swift
//  TODO
//
//  Created by 오정석 on 6/11/2025.
//

import Combine
import Observation
import Foundation

@Observable
class AdvancedSearchViewModel {
    @Published var titleQuery = ""
    @Published var priorityFilter: Int? = nil
    @Published var dateFilter: Date? = nil
    @Published var searchResult: [TodoItem] = []
    
    private var cancellable = Set<AnyCancellable>()
    private let allTodos: [TodoItem] = []
    
    init() {
        Publishers.CombineLatest3 (
            $titleQuery.debounce(for: .seconds(0.3), scheduler: RunLoop.main),
            $priorityFilter,
            $dateFilter
        )
        .map { [weak self] title, priority, date -> [TodoItem] in
            guard let self = self else { return [] }
            
            var filtered = self.allTodos
            
            // 제목 필터
            if !title.isEmpty {
                filtered = filtered.filter({ $0.title.localizedCaseInsensitiveContains(title) })
            }
            
            // 우선 순위 필터
            if let priority = priority {
                filtered = filtered.filter({ $0.priority == priority })
            }
            
            if let date = date {
                filtered = filtered.filter {
                    Calendar.current.isDate($0.createdAt, inSameDayAs: date)
                }
            }
            
            return filtered
        }
        .assign(to: &$searchResult)
    }
}
