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
    }

    func go(context: CommandContext) -> CommandAction {
        guard context.hasArgs else {
            return .showUsage("Usage: go #area.room:instance")
        }
        
        let chosenRoom: Room
        
        switch context.scanArgument(type: [.areaInstance, .room]) {
        case .room(let room):
            chosenRoom = room
        case .areaInstance(let areaInstance):
            guard let room = areaInstance.roomsById.first?.value else {
                context.send("Area instance #\(areaInstance.area.id):\(areaInstance.index) contains no rooms")
                return .accept
            }
            chosenRoom = room
        default: return .accept
        }
        
        context.player?.room = chosenRoom
     
        let area = chosenRoom.areaInstance.area
        
        context.send("Relocated to #\(area.id).\(chosenRoom.id):\(chosenRoom.areaInstance.index)")
        return .accept
    }
}
