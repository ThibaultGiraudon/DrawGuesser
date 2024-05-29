//
//  String+removeAccent.swift
//  DrawTogether
//
//  Created by Thibault Giraudon on 27/05/2024.
//

import Foundation

extension String {
    func removeAccents() -> String {
        let mutableString = NSMutableString(string: self) as CFMutableString
        CFStringTransform(mutableString, nil, kCFStringTransformStripCombiningMarks, false)
        return mutableString as String
    }
}
