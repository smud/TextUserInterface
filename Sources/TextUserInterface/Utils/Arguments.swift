//
// Arguments.swift
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

public class Arguments {
	typealias T = Arguments
	
	public let scanner: Scanner
	
	public var isAtEnd: Bool {
		return scanner.isAtEnd
	}

	static let whitespaceAndNewline = CharacterSet.whitespacesAndNewlines
	
	public init(scanner: Scanner) {
		self.scanner = scanner
	}
	
	public func scanWord() -> String? {
        return scanner.scanUpToCharacters(from: T.whitespaceAndNewline)
	}
	
	public func scanWords() -> [String] {
		var words = [String]()
		while let word = scanWord() {
			words.append(word)
		}
		return words
	}
	
	public func scanInt() -> Int? {
		guard let word = scanWord() else {
			return nil
		}
		let validator = Scanner(string: word)
		validator.charactersToBeSkipped = nil
		guard let value = validator.scanInteger(), validator.isAtEnd else {
			return nil
		}
		return value
	}
	
    public func scanInt64() -> Int64? {
        guard let word = scanWord() else {
            return nil
        }
        let validator = Scanner(string: word)
        validator.charactersToBeSkipped = nil
        guard let value = validator.scanInt64(), validator.isAtEnd else {
            return nil
        }
        return value
    }
    
	public func scanDouble() -> Double? {
		guard let word = scanWord() else {
			return nil
		}
		let validator = Scanner(string: word)
		validator.charactersToBeSkipped = nil
		guard let value = validator.scanDouble(), validator.isAtEnd else {
			return nil
		}
		return value
	}
	
	public func scanRestOfString() -> String? {
		return scanner.scanUpTo("")
	}
	
	public func skipRestOfString() {
		let _ = scanner.skipUpTo("")
	}
    
    //public func scanTag() -> Tag? {
    //    let scanLocation = scanner.scanLocation
    //    guard let word = scanWord(), word.hasPrefix("#"), let tag = Tag(word) else {
    //        scanner.scanLocation = scanLocation
    //        return nil
    //    }
    //    return tag
    //}
}
