//
// Session.swift
//
// This source file is part of the SMUD open source project
//
// Copyright (c) 2016 SMUD project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SMUD project authors
//

import Smud

public protocol Session: class {
    var textUserInterface: TextUserInterface { get }
    var context: SessionContext? { get set }

    var account: Account? { get set }
    var creature: Creature? { get set }

    func send(items: [Any], separator: String, terminator: String, isPrompt: Bool)
}

public extension Session {    
    func send(items: [Any], separator: String = "", terminator: String = "\n") {
        send(items: items, separator: separator, terminator: terminator, isPrompt: false)
    }
    
    func send(_ items: Any..., separator: String = "", terminator: String = "\n") {
        send(items: items, separator: separator, terminator: terminator)
    }

    func sendPrompt(items: [Any], separator: String = "", terminator: String = "\n") {
        var items = items
        items.insert("\n", at: 0)
        send(items: items, separator: separator, terminator: "", isPrompt: true)
    }
    
    func sendPrompt(_ items: Any..., separator: String = "", terminator: String = "\n") {
        sendPrompt(items: items, separator: separator, terminator: "")
    }
}
