//
//  KeyChain.swift
//  QiitaArticleViewer
//
//  Created by kaito-seita on 2023/11/22.
//

import Foundation

class KeyChain {
    
    static let shared = KeyChain()
    init() {}
    
    func save(_ data: Data, service: String, key: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key,
        ] as CFDictionary
        
        let matchingStatus = SecItemCopyMatching(query, nil)
        switch matchingStatus {
        case errSecItemNotFound:
            SecItemAdd(query, nil)
        case errSecSuccess:
            SecItemUpdate(query, [kSecValueData as String: data] as CFDictionary)
        default:
            print("Failed to save data to keychain")
        }
    }
    
    func read(service: String, key: String) -> String? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        if let data = (result as? Data) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func delete(service: String, key: String) -> Bool {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: key,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == noErr
    }
}
