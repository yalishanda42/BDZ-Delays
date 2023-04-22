//
//  RovrHTMLCoder.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 22.04.23.
//

import Foundation

enum RovrHTMLCoder {
    enum ParseError: Error {
        case dataDecodingError
    }
    
    static func decode(pageData: Data) throws -> String {
        if let decoded = String(data: pageData, encoding: .windowsCP1251) {
            return decoded
        }
        
        throw ParseError.dataDecodingError
    }
    
    static func parseHTML(_ htmlString: String) -> Void {
        // TODO
    }
}
