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
        guard context.hasArgs else {
            return .showUsage("Kill whom?")
        }
        
        let victim: Creature
        switch context.scanArgument(type: [.creature]) {
        case .creature(let creature):
            context.send("Will attack \(creature.name)")
            victim = creature
        default:
            return .accept
        }

        return .accept
    }
}
