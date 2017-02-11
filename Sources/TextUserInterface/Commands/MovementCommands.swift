//
// MovementCommands.swift
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

class MovementCommands {
    func register(with router: CommandRouter) {
        router["go"] = go
        router["north"] = { return self.move(.north, $0) }
        router["east"] = { return self.move(.east, $0) }
        router["south"] = { return self.move(.south, $0) }
        router["west"] = { return self.move(.west, $0) }
        router["up"] = { return self.move(.up, $0) }
        router["down"] = { return self.move(.down, $0) }
    }

    func go(context: CommandContext) -> CommandAction {
        guard let selector = context.args.scanSelector() else {
            return .showUsage("Usage: go #area.origin | #area.room:instance | #area.mobile:instance | #area.item:instance")
        }
        
        guard let result = context.creature.findOne(selector: selector, entityTypes: [.creature, .room], locations: .world) else {
            context.send("No rooms or creatures found.")
            return .accept
        }

        let chosenRoom: Room

        switch result {
        case .creature(let creature):
            guard let room = creature.room else {
                context.send("This creature is not standing in any room.")
                return .accept
            }
            chosenRoom = room
        case .room(let room):
            chosenRoom = room
        default:
            assertionFailure()
            return .accept
        }
        
        context.creature.room = chosenRoom
     
        context.send("Relocated to \(Link(room: chosenRoom)))")
        return .accept
    }

    func move(_ direction: Direction, _ context: CommandContext) -> CommandAction {
        return move(direction: direction, context: context)
    }

    func move(direction: Direction, context: CommandContext) -> CommandAction {
        
        guard let room = context.room else {
            context.send("You aren't standing in any room.")
            return .accept
        }
        
        if let room = room.resolveExit(direction: direction) {
            //context.send("You move \(direction).")
            context.creature.room = room
            context.creature.look()
        } else {
            context.send("You can't move in that direction.")
        }
        
        return .accept
    }
}
