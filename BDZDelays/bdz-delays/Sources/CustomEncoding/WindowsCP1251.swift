//
//  WindowsCP1251.swift
//  BDZDelays
//
//  Created by Alexander Ignatov on 24.04.23.
//

import Foundation

/// https://en.wikipedia.org/wiki/Windows-1251
public struct WindowsCP1251: Unicode.Encoding {
    
    public typealias CodeUnit = UInt8
    public typealias EncodedScalar = CollectionOfOne<CodeUnit>
    public typealias ForwardParser = Parser
    public typealias ReverseParser = Parser
    
    public struct Parser: Unicode.Parser {
        public typealias Encoding = WindowsCP1251
        
        public init() {}
        
        public mutating func parseScalar<I>(from input: inout I) -> Unicode.ParseResult<EncodedScalar>
        where I: IteratorProtocol, I.Element == CodeUnit {
            guard let raw = input.next() else {
                return .emptyInput
            }
            
            switch raw {
            case 0x98:
                return .error(length: 1)
            default:
                return .valid(.init(raw))
            }
        }
    }
    
    public static var encodedReplacementCharacter: EncodedScalar { fatalError() }
    
    public static func decode(_ content: EncodedScalar) -> Unicode.Scalar {
        let byte = content.first!
        switch byte {
        case 0xC0...0xFF:
            // The cyrillic letters are in an array 0xC0...0xFF
            // in the same order as in Unicode 0x0410...0x044F
            // => just shift the value
            return .init(UInt32(byte) - 0xC0 + 0x0410)!
            
        // TODO: Convert 0x80...0xBF appropriately
            
        default:
            // The rest matches Unicode
            return .init(byte)
        }
    }

    public static func encode(_ content: Unicode.Scalar) -> EncodedScalar? {
        let uniCode = content.value
        switch uniCode {
        case 0x0410...0x044F:
            return .init(.init(exactly: uniCode - 0x0410 + 0xC0)!)
            
        // TODO: Handle cases for returning 0x80...0xBF
            
        case 0...0xFF:
            return .init(.init(uniCode))
        
        default:
            return nil
        }
    }
}
