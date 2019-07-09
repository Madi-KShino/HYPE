//
//  Hype.swift
//  HYPE
//
//  Created by Madison Kaori Shino on 7/9/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import Foundation
import CloudKit

//CONSTANT MAGIC STRINGS
//(Static to be able to access outside of this struct)
struct Constants {
    static let recordTypeKey = "Hype"
    fileprivate static let recordTextKey = "Text"
    fileprivate static let recordTimeStampKey = "Timestamp"
}

class Hype {
    
    //PROPERTIES
    let hypeText: String
    let timeStamp: Date
    
    //DESIGNATED (MEMBERWISE) INITIALIZER TO CREATE A HYPE MESSAGE
    init(hypeText: String, timeStamp: Date = Date()) {
        self.hypeText = hypeText
        self.timeStamp = timeStamp
    }
}

//CONVENIENCE INIT TO CREATE A HYPE MESSAGE FROM A RECORD
extension Hype {
    convenience init?(ckRecord: CKRecord) {
        guard let hypeText = ckRecord[Constants.recordTextKey] as? String,
            let timeStamp = ckRecord[Constants.recordTimeStampKey] as? Date
            else { return nil }
        self.init(hypeText: hypeText, timeStamp: timeStamp)
    }
}

//CONVENIENCE INIT TO CREATE A RECORD
extension CKRecord {
    convenience init(hype: Hype) {
        self.init(recordType: Constants.recordTypeKey)
        self.setValue(hype.hypeText, forKey: Constants.recordTextKey)
        self.setValue(hype.timeStamp, forKey: Constants.recordTimeStampKey)
    }
}
