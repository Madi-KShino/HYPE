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
            self.hypes.append(hype)
            completion(true)
        }
    }
    
    //FETCH
    func fetchHype(completion: @escaping (Bool) -> Void) {
        
    }
    
    //SUBSCRIPTION
//    func subscribeToRemoteNotifications(completion: @escaping (Error?) -> Void) {
//        <#function body#>
//    }
}
