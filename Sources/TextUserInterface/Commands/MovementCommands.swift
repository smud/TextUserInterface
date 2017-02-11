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
        guard context.hasArgs else {
            return .showUsage("Usage: go #area.room:instance")
        }
        
        let chosenRoom: Room
        
        switch context.scanArgument(type: [.room, .areaInstance]) {
        case .room(let room):
            chosenRoom = room
        case .areaInstance(let areaInstance):
            guard let room = areaInstance.roomsById.first?.value else {
                context.send("Area instance #\(areaInstance.area.id):\(areaInstance.index) contains no rooms")
                return .accept
            }
            chosenRoom = room
        default:
            context.send("Location not found: \(context.args.scanRestOfString() ?? "")")
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
