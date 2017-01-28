//
// Scanner+Arguments.swift
//
// This source file is part of the SMUD open source project
//
// Copyright (c) 2016 SMUD project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SMUD project authors
//

import Foundation
import ScannerUtils
import Smud

extension Scanner {
    public func scanWord() -> String? {
        return scanUpToCharacters(from: CharacterSet.whitespacesAndNewlines)
    }
    
    @discardableResult
    public func skipWord() -> Bool {
        return scanWord() != nil
    }
    
    public func scanWords() -> [String] {
        var words = [String]()
        while let word = scanWord() {
            words.append(word)
        }
        return words
    }

    public func scanLink() -> Link? {
        let scanLocation = self.scanLocation
        guard let word = scanWord(), word.hasPrefix("#"), let link = Link(word) else {
            self.scanLocation = scanLocation
            return nil
        }
        return link
    }

    public func scanRestOfString() -> String? {
        return scanUpTo("")
    }
    
    public func skipRestOfString() {
        let _ = skipUpTo("")
    }
}
