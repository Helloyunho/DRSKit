//
//  SeqOrig.swift
//  
//
//  Created by Helloyunho on 8/8/23.
//

import Foundation

public struct SeqOrig: Codable {
    public struct SeqData: Codable {
        public let version: Int32
        
        public enum CodingKeys: String, CodingKey {
            case version = "seq_version"
        }
        
        public init(version: Int32) {
            self.version = version
        }
    }

    public let data: SeqData
    
    public init(data: SeqData) {
        self.data = data
    }
}
