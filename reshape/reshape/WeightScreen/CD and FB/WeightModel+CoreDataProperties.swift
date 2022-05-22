//
//  WeightModel+CoreDataProperties.swift
//  reshape
//
//  Created by Иван Фомин on 23.04.2022.
//
//

import Foundation
import CoreData


extension WeightModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeightModel> {
        return NSFetchRequest<WeightModel>(entityName: "WeightModel")
    }

    @NSManaged public var modelDate: String?
    @NSManaged public var modelID: Int32
    @NSManaged public var modelTime: String?
    @NSManaged public var modelWeight: String?

}

extension WeightModel : Identifiable {

}
