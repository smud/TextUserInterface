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

class MovementCommands {
    func register(with router: CommandRouter) {
        router["go"] = go
    }

    func go(context: CommandContext) -> CommandAction {
        guard context.hasArgs else {
            return .showUsage("Usage: go #area.room:instance\n" +
                "Area and room can be omitted.")
        }
        
        guard let room = context.scanRoom() else { return .accept }
        
        context.player?.room = room
     
        let area = room.areaInstance.area
        
        context.send("Relocated to #\(area.id).\(room.id):\(room.areaInstance.index)")
        return .accept
    }
}
