//
//  String+extensions.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 16/09/23.
//

import Foundation

extension String {
    
    // String with no spaces or new lines in beginning and end.
    
    var isEmptyOrWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // String without spaces and new lines.
    
    var withoutSpaceOrNewLines: String {
        return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    // Date object from "yyyy-MM-dd HH:mm:ss" formatted string.
    
    var dateFromString: Date? {
            let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.date(from: selfLowercased)
        }
    
    // Check if string is valid email format.
    
    var isValidEmail: Bool {
            // http://emailregex.com/
            let regex =
                "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
            return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
        }
}
