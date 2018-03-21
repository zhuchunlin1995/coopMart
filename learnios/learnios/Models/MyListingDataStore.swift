//
//  MyListingDataStore.swift
//  learnios
//
//  Created by Guanming Qiao on 3/21/18.
//

import Foundation

class MyListingDataStore {
    static let sharedInstance = MyListingDataStore()
    var currentListing: ListingModel?
    
    private init() { }
}
