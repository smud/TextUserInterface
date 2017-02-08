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
        let prompt = makePrompt(session: session)
        session.sendPrompt(prompt)
    }
    
    func processResponse(args: Scanner, session: Session) throws -> ContextAction {
        
        guard let creature = session.creature else {
            print("Session doesn't have an associated creature")
            return .retry(reason: smud.internalErrorMessage)
        }
        
        let router = session.textUserInterface.router
        router.process(args: args, creature: creature, session: session,
            unknownCommand: { context in
                context.send("Unknown command: \(context.args.scanWord().unwrapOptional)")
            },
            partialMatch: { context in
                context.send("Warning! Part of your input was ignored: \(context.args.scanRestOfString().unwrapOptional)")
            }
        )
        
        return .retry(reason: nil)
    }
    
    private func makePrompt(session: Session) -> String {
        var prompt = ""

        if let creature = session.creature {
            
            if let room = creature.room {
                prompt += areaAndRoom(room: room)
                prompt += " "
                prompt += exits(room: room)
            }
            
        }
        
        prompt += "> "
        return prompt
    }
    
    private func areaAndRoom(room: Room) -> String {
        return "\(room.areaInstance.area.id).\(room.id):\(room.areaInstance.index)"
    }
    
    private func exits(room: Room) -> String {
        var result = "Exits:"
        
        for direction in room.orderedDirections {
            result += direction.abbreviated.capitalizingFirstLetter()
        }
        
        return result
    }
}
