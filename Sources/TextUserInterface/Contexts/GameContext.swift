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

final class GameContext: SessionContext {
    static var name = "game"
    let smud: Smud
    
    init(smud: Smud) {
        self.smud = smud
    }
    
    func greet(session: Session) {
        session.sendPrompt("> ")
    }
    
    func processResponse(args: Arguments, session: Session) throws -> ContextAction {
        
        guard let _ /*player*/ = session.player else {
            print("Session doesn't have an associated player")
            return .retry(reason: smud.internalErrorMessage)
        }
//        Commands.router.process(args: args,
//                                player: player,
//                                connection: connection,
//                                unknownCommand: { context in
//            session.send("Unknown command: \(context.args.scanWord().unwrapOptional)")
//        },
//                                partialMatch: { context in
//            session.send("Warning! Part of your input was ignored: \(context.args.scanRestOfString().unwrapOptional)")
//                                    
//        })
        
        return .retry(reason: nil)
    }
}
