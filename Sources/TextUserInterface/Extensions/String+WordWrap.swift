//
//  String+WordWrap.swift
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

extension String {
    public func wrapping(aroundTextColumn column: String, totalWidth: Int, rightMargin: Int = 0, bottomMargin: Int = 0) -> String {

        let columnLines = column.components(separatedBy: "\n") + Array(repeating: "", count: bottomMargin)
        let columnWidth = (columnLines.map{ $0.characters.count }.max() ?? -rightMargin) + rightMargin

        var lines = [String]()

        struct CurrentLine {
            var content = ""
            var length = 0
            var number = 0
            mutating func append(_ string: String, length: Int?) {
                content += string
                self.length += length ?? string.characters.count
            }
            mutating func advance() -> String {
                defer { content = "" }
                length = 0
                number += 1
                return content
            }
        }

        struct CurrentWord {
            var content = ""
            mutating func eat(_ length: Int) -> String {
                let index = content.index(content.startIndex, offsetBy: length)
                defer { content = content[index..<content.endIndex] }
                return content[content.startIndex..<index]
            }
            mutating func eatAll() -> String {
                defer { content = "" }
                return content
            }
        }

        var currentLine = CurrentLine()
        var currentWord = CurrentWord()

        let wordCharacterSet = CharacterSet.whitespacesAndNewlines.inverted
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = CharacterSet.whitespaces

        while !scanner.isAtEnd {
            let firstWordInLine = currentLine.length == 0
            if firstWordInLine && currentLine.number < columnLines.count {
                let paddedColumn = columnLines[currentLine.number].padding(toLength: columnWidth, withPad: " ", startingAt: 0)
                currentLine.append(paddedColumn, length: columnWidth)
            }

            if currentWord.content.isEmpty {
                if scanner.skipString("\n") {
                    lines.append(currentLine.advance())
                    continue
                }
                
                guard let word = scanner.scanCharacters(from:wordCharacterSet) else {
                    assert(false)
                    continue
                }
                currentWord.content = word
            }

            let wordLength = currentWord.content.characters.count

            if currentLine.length + wordLength >= totalWidth {
                if firstWordInLine {
                    let remainingLength = totalWidth - currentLine.length
                    currentLine.append(currentWord.eat(remainingLength), length: remainingLength)
                }

                lines.append(currentLine.advance())
                continue
            }

            if !firstWordInLine {
                currentLine.append(" ", length: 1)
            }

            currentLine.append(currentWord.eatAll(), length: wordLength)
        }

        if currentLine.length > 0 {
            lines.append(currentLine.advance())
        }

        if (currentLine.number < columnLines.count) {
            lines += columnLines[currentLine.number..<columnLines.count]
        }

        return lines.joined(separator: "\n")
    }
}
