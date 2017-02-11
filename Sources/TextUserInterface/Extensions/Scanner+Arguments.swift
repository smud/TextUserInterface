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
        guard let word = scanWord(), let link = Link(word) else {
            self.scanLocation = scanLocation
            return nil
        }
        return link
    }

    public func scanPattern() -> EntityPattern? {
        let scanLocation = self.scanLocation
        guard let word = scanWord() else {
            self.scanLocation = scanLocation
            return nil
        }
        let pattern = EntityPattern(word)
        return pattern
    }
    
    public func scanSelector() -> EntitySelector? {
        // FIXME: EntitySelector should be constructible from scanner. Workaround:
        if let word = scanWord() {
            return EntitySelector(word)
        }
        return nil
    }
    
    public func scanRestOfString() -> String? {
        return scanUpTo("")
    }
    
    public func skipRestOfString() {
        let _ = skipUpTo("")
    }
}
