//
// MainMenuContext.swift
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
import Smud

final class MainMenuContext: SessionContext {
    static var name = "mainMenu"
    let smud: Smud
    
    init(smud: Smud) {
        self.smud = smud
    }
    
    func greet(session: Session) {
        guard let name = session.player?.name else { return }
        session.sendPrompt(
            "Welcome \(name)!\n" +
            "1. Play\n" +
            "0. Exit\n" +
            "What would you like to do? ")
    }
    
    func processResponse(args: Arguments, session: Session) -> ContextAction {
        guard let optionIndex = args.scanInt() else {
            return .retry(reason: "Please enter a number.")
        }
        switch optionIndex {
        case 1:
            return .next(context: GameContext(smud: smud))
        case 0:
            session.send("Goodbye!")
            return .closeSession
        default:
            break
        }
        return .retry(reason: "Unknown option.")
    }
}
