//
// TextUserInterface.swift
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

public class TextUserInterface {
    public let router = CommandRouter()
    
    let movementCommands = MovementCommands()
    let fightCommands = FightCommands()
    let infoCommands = InfoCommands()
    let adminCommands = AdminCommands()
    let instanceCommands = InstanceCommands()

    public init() {
    }
    
    public func registerCommands() {
        movementCommands.register(with: router)
        fightCommands.register(with: router)
        infoCommands.register(with: router)
        adminCommands.register(with: router)
        instanceCommands.register(with: router)
        //RoomEditorCommands.register(with: router)
        //AreaEditorCommands().register(with: router)
    }
}
