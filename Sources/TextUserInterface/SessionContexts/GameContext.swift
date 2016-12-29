//
// GameContext.swift
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
import StringUtils

final class GameContext: SessionContext {
    static var name = "game"
    let smud: Smud
    
    init(smud: Smud) {
        self.smud = smud
    }
    
    func greet(session: Session) {
        session.sendPrompt("> ")
    }
    
    func processResponse(args: Scanner, session: Session) throws -> ContextAction {
        
        guard let player = session.player else {
            print("Session doesn't have an associated player")
            return .retry(reason: smud.internalErrorMessage)
        }
        
        let router = session.textUserInterface.router
        router.process(args: args, player: player, session: session,
            unknownCommand: { context in
                context.send("Unknown command: \(context.args.scanWord().unwrapOptional)")
            },
            partialMatch: { context in
                context.send("Warning! Part of your input was ignored: \(context.args.scanRestOfString().unwrapOptional)")
            }
        )
        
        return .retry(reason: nil)
    }
}
