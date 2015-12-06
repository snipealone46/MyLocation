//
//  Location.swift
//  MyLocations
//
//  Created by Shaohui Yang on 12/2/15.
//  Copyright © 2015 Shaohui Yang. All rights reserved.
//

import Foundation
import CoreData
import MapKit


class Location: NSManagedObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    var title: String? {
        if locationDescription.isEmpty {
            return "(No Description"
        } else {
            return locationDescription
        }
    }
    
    var subtitle: String? {
        return category
    }

}
