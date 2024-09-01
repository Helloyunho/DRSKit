//
//  Int32WithType+DynamicNodeEncoding.swift
//  DRSKit
//
//  Created by Helloyunho on 2024/9/1.
//
import DRSKit
import XMLCoder

extension Int32WithType: @retroactive DynamicNodeEncoding {
    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch key {
        case CodingKeys.__type:
            return .attribute
        default:
            return .element
        }
    }
}
