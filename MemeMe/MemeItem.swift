//
//  MemeItem.swift
//  MemeMe
//
//  Created by Che-Chuen Ho on 3/23/15.
//  Copyright (c) 2015 Che-Chuen Ho. All rights reserved.
//

import Foundation
import CoreData

@objc(MemeItem)

class MemeItem: NSManagedObject {

    @NSManaged var topLabel: String
    @NSManaged var bottomLabel: String
    @NSManaged var image: NSData
    @NSManaged var originalImage: NSData

}
