//
//  KeyChainManager.swift
//  GitHub Viewer
//
//  Created by Oleksandr Oliinyk on 14.06.2022.
//

import Foundation

final class KeyChainManager {
    
    private enum KeychainError: Error {
        case duplicateEntry
        case invalidToken
        case unhandledError(OSStatus)
        case unknown(OSStatus)
        case noPassword
        case unexpectedPasswordData
    }
    static func save(credentials: CredentialsModel) throws {
        guard let accessToken = credentials.personalToken.accessToken.data(using: String.Encoding.utf8) else { throw KeychainError.invalidToken }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: credentials.account,
            kSecAttrServer as String: credentials.server,
            kSecValueData as String: accessToken
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else { throw KeychainError.duplicateEntry }
        guard status == errSecSuccess else { throw KeychainError.unknown(status) }
    }
    
//    static func get(account: String, service: String) throws -> CredentialsModel {
//        let query: [String: Any] = [
//            kSecClass as String: kSecClassInternetPassword,
//            kSecAttrAccount as String: account,
//            kSecAttrServer as String: service,
//            kSecMatchLimit as String: kSecMatchLimitOne,
//            kSecReturnData as String: kCFBooleanTrue ?? true
//        ]
//        
//        var result: CFTypeRef?
//        let status = SecItemCopyMatching(query as CFDictionary, &result)
//        
//        guard status != errSecItemNotFound else { throw KeychainError.noPassword}
//        guard status == errSecSuccess else { throw KeychainError.unhandledError(status)}
//        
//        guard let existingItem = result as? [String: Any],
//              let tokenData = existingItem[kSecValueData as String] as? Data,
//              let token = String(data: tokenData, encoding: String.Encoding.utf8),
//              let account = existingItem[kSecAttrAccount as String] as? String,
//              let server = existingItem[kSecAttrServer as String] as? String
//        else { throw KeychainError.unexpectedPasswordData }
//        
//        return CredentialsModel(account: account, personalToken: token, server: server)
//    }
}
