//
//  Seq+Import.swift
//  DRSKit
//
//  Created by Helloyunho on 2024/8/21.
//
import Foundation
import DRSKit
import XMLCoder

public enum SeqImportError: Error {
    case invalidVersion
    case notUTF8
}

extension Seq {
    public static func importXML(content: String) throws -> Seq {
        guard let data = content.data(using: .utf8) else { throw SeqImportError.notUTF8 }
        return try importXML(data)
    }
    
    public static func importXML(_ xmlFileURL: URL) throws -> Seq {
        let data = try Data(contentsOf: xmlFileURL)
        return try importXML(data)
    }
    
    public static func importXML(_ xmlFilePath: String) throws -> Seq {
        let data: Data
        if #available(iOS 16.0, macOS 13.0, *) {
            data = try Data(contentsOf: URL(filePath: xmlFilePath))
        } else {
            data = try Data(contentsOf: URL(fileURLWithPath: xmlFilePath))
        }
        
        return try importXML(data)
    }
    
    public static func importXML(_ xmlData: Data) throws -> Seq {
        var result: Seq9.SeqData!
        let decoder = XMLDecoder()
        let decoded = try decoder.decode(SeqOrig.SeqData.self, from: xmlData)
        switch decoded.version {
        case 8:
            let allDecoded = try decoder.decode(
                Seq8.SeqData.self, from: xmlData)
            result = convert8To9(from: allDecoded)
        case 9:
            result = try decoder.decode(Seq9.SeqData.self, from: xmlData)
        default:
            throw SeqImportError.invalidVersion
        }
        
        return parseFromSeq9(Seq9(data: result))
    }
}
