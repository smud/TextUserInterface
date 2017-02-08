//
// FightCommands.swift
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

public class FightCommands {
    func register(with router: CommandRouter) {
        router["kill"] = kill
    }
    
    func kill(context: CommandContext) -> CommandAction {
        guard let selector = context.args.scanSelector() else {
            return .showUsage("Kill whom?")
        }
        
        guard let creature = context.creature.findCreature(selector: selector, locations: .room) else {
            context.send("No one with this name here.")
            return .accept
        }
        
        //context.send("Will attack \(creature.name)")
        context.room?.fight.start(attacker: context.creature, victim: creature)

        return .accept
    }
}
