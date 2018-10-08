//
//  Movie+CoreDataProperties.swift
//  
//
//  Created by Omer Cohen on 10/7/18.
//
//

import Foundation
import CoreData


extension Movie  {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var rating: String?
    @NSManaged public var image: String?
    @NSManaged public var attribute: Double
    @NSManaged public var genre: String?
    @NSManaged public var releaseYear: Double

}
