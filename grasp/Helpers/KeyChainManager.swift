//
//  KeyChainManager.swift
//  grasp
//
//  Created by Charles Bai on 2017-11-13.
//  Copyright © 2017 Charles Bai. All rights reserved.
//

import Foundation
import KeychainSwift

class KeyChainManager {
    static let sharedInstance = KeyChainManager()
    let keychain = KeychainSwift()
    
    func storeValueFor(_ key: String, value: String) {
        keychain.set(value, forKey: key)
    }
    
    func retrieveValueFor(_ key: String) -> String {
        let value = keychain.get(key) ?? ""
        return value
    }
    
    func deleteValueFor(_ key: String) {
        keychain.delete(key)
    }
}
