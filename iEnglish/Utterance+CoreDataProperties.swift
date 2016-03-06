//
//  Utterance+CoreDataProperties.swift
//  iEnglish
//
//  Created by Mulang Su on 1/31/16.
//  Copyright © 2016 Mulang Su. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Utterance {

    @NSManaged var string: String?
    @NSManaged var playlist: Playlists?

}
