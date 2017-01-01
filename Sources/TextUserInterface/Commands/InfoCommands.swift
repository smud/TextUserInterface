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
    func register(with router: CommandRouter) {
        router[""] = refreshPrompt
        router["look"] = look
    }
    
    func refreshPrompt(context: CommandContext) -> CommandAction {
        return .accept
    }
    
    func look(context: CommandContext) -> CommandAction {
        context.creature.look()
        
        return .accept
    }
}
