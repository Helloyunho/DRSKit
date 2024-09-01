//
//  Seq+Export.swift
//  DRSKit
//
//  Created by Helloyunho on 2024/9/1.
//
import Foundation
import DRSKit
import XMLCoder

extension Seq {
    public func exportXML(_ xmlFileURL: URL) throws {
        let data = try exportXML()
        try data.write(to: xmlFileURL)
    }
    
    public func exportXML(_ xmlFilePath: String) throws {
        let url: URL
        if #available(iOS 16.0, macOS 13.0, *) {
            url = URL(filePath: xmlFilePath)
        } else {
            url = URL(fileURLWithPath: xmlFilePath)
        }
        
        try exportXML(url)
    }
    
    public func exportXML() throws -> Data {
        let seq9 = self.convertToSeq9()
        let encoder = XMLEncoder()
        let xml = try encoder.encode(seq9.data, withRootKey: "data", header: XMLHeader(version: 1.0, encoding: "utf-8"))

        return Data([0xEF, 0xBB, 0xBF]) + xml
    }
}
