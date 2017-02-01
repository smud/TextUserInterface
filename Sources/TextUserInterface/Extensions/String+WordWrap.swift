//
//  String+WordWrap.swift
//  DemoMUD
//
//  Created by Anton Karandeev on 01/02/2017.
//
//

import Foundation

extension String {
    public func wrapping(aroundTextColumn column: String, totalWidth: Int, rightMargin: Int = 0, bottomMargin: Int = 0) -> String {

        let columnLines = column.components(separatedBy: "\n") + Array(repeating: "", count: bottomMargin)
        let columnWidth = (columnLines.map{ $0.characters.count }.max() ?? -rightMargin) + rightMargin

        var lines = [String]()
        var currentLine = ""
        var currentLineNumber = 0
        var currentLineLength = 0

        let wordCharacterSet = CharacterSet.whitespacesAndNewlines.inverted
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = CharacterSet.whitespaces

        while !scanner.isAtEnd {
            let firstWordInLine = currentLineLength == 0
            if firstWordInLine && currentLineNumber < columnLines.count {
                if currentLineNumber < columnLines.count {
                    currentLine += columnLines[currentLineNumber].padding(toLength: columnWidth, withPad: " ", startingAt: 0)
                } else {
                    currentLine += String(repeating: " ", count: columnWidth)
                }
                currentLineLength = columnWidth
            }

            if scanner.skipString("\n") {
                if currentLineLength > 0 {
                    lines.append(currentLine)
                }

                currentLine = ""
                currentLineLength = 0
                currentLineNumber += 1
                continue
            }

            guard let word = scanner.scanCharacters(from:wordCharacterSet) else {
                assert(false)
                continue
            }

            let wordLength = word.characters.count
            if currentLineLength == 0 || currentLineLength + wordLength < totalWidth {
                if !firstWordInLine {
                    currentLine += " "
                    currentLineLength += 1
                }
                currentLine += word
                currentLineLength += wordLength
            } else if currentLineLength > 0 {
                lines.append(currentLine)
                currentLine = ""
                currentLineLength = 0
                currentLineNumber += 1
            }
        }

        if currentLineLength > 0 {
            lines.append(currentLine)
            currentLineNumber += 1
        }

        if (currentLineNumber < columnLines.count) {
            lines += columnLines[currentLineNumber..<columnLines.count]
        }

        return lines.joined(separator: "\n")
    }
}
