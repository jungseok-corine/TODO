//
//  TodoEntity+CoreDataProperties.swift
//  TODO
//
//  Created by 오정석 on 5/11/2025.
//
//

public import Foundation
public import CoreData


public typealias TodoEntityCoreDataPropertiesSet = NSSet

extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }

    @NSManaged public var priority: Int16
    @NSManaged public var updatedAt: Date?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var detail: String?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?

}

extension TodoEntity : Identifiable {

}
