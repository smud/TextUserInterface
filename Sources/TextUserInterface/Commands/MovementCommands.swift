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
        guard let selector = context.args.scanSelector(),
            let result = context.creature.findOne(selector: selector, entityTypes: .creature, locations: .world)
        else {
            return .showUsage("Usage: go #area.origin | #area.room:instance | #area.mobile:instance | #area.item:instance")
        }

        let chosenRoom: Room

        switch result {
        case .creature(let creature):
            guard let room = creature.room else {
                context.send("This creature is not standing in any room.")
                return .accept
            }
            chosenRoom = room
        default:
            return .accept
        }
        
//
//        let results = context.creature.find(selector: selector, entityTypes: [.creature], locations: .world)
//        guard results.count == 1 else {
//            context.send("Can't go to multiple places at the same time.")
//            return .accept
//        }
//        
//        switch context.scanArgument(type: [.room, .areaInstance]) {
//        case .room(let room):
//            chosenRoom = room
//        case .areaInstance(let areaInstance):
//            guard let room = areaInstance.roomsById.first?.value else {
//                context.send("Area instance #\(areaInstance.area.id):\(areaInstance.index) contains no rooms")
//                return .accept
//            }
//            chosenRoom = room
//        default:
//            return .accept
//        }
        
        context.creature.room = chosenRoom
     
        let area = chosenRoom.areaInstance.area
        
        context.send("Relocated to #\(area.id).\(chosenRoom.id):\(chosenRoom.areaInstance.index)")
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
