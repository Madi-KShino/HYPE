//
//  HypeController.swift
//  HYPE
//
//  Created by Madison Kaori Shino on 7/9/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CloudKit

class HypeController {
    
    //PROPERTIES
    let publicDataBase = CKContainer.default().publicCloudDatabase
    static let sharedInstance = HypeController()
    var hypes: [Hype] = []
    
    //CRUD FUNCTIONS
    
    //SAVE
    func saveHype(text: String, completion: @escaping (Bool) -> Void) {
        //hype to save
        let hype = Hype(hypeText: text)
        //record to save from a hype
        let hypeRecord = CKRecord(hype: hype)
        //save record
        publicDataBase.save(hypeRecord) { (_, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            //append hype created to local souce of truth
            self.hypes.insert(hype, at: 0)
            completion(true)
        }
    }
    
    //FETCH
    func fetchHype(completion: @escaping (Bool) -> Void) {
        //create predicate for query
        let predicate = NSPredicate(value: true)
        //create query with a record type (from model) and predicate
        let query = CKQuery(recordType: Constants.recordTypeKey, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: Constants.recordTimeStampKey, ascending: false)]
        //perform query through the public database (using query, zone, completion handler)
        publicDataBase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            //convert records (if there are any) into hypes
            guard let records = records else { completion(false); return }
            let hypes = records.compactMap({Hype(ckRecord: $0)})
            self.hypes = hypes
            completion(true)
        }
    }
    
    //SUBSCRIPTION
    //    func subscribeToRemoteNotifications(completion: @escaping (Error?) -> Void) {
    //        <#function body#>
    //    }
}
