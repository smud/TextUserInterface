//
// InfoCommands.swift
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

class InfoCommands {
    static func register(with router: CommandRouter) {
        router[""] = refreshPrompt
        router["look"] = look
    }
    
    static func refreshPrompt(context: CommandContext) -> CommandAction {
        return .accept
    }
    
    static func look(context: CommandContext) -> CommandAction {
        guard let room = context.player.room else {
            context.send("You aren't standing in any room.")
            return .accept
        }
        
        context.send(room.title)
        
        return .accept
    }
}
