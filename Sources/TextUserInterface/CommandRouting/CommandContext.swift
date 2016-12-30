//
// CommandContext.swift
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

public class CommandContext {
    struct GameObjectType: OptionSet {
        let rawValue: Int
        
        static let areaInstance = GameObjectType(rawValue: 1 << 0)
        static let room = GameObjectType(rawValue: 1 << 1)
    }
    
    enum GameObject {
        case none
        case areaInstance(AreaInstance)
        case room(Room)
    }
    
    let args: Scanner
    var hasArgs: Bool { return !args.isAtEnd }
    
    let creature: Creature
    let session: Session
    let userCommand: String

    var player: Player? { return creature as? Player }
    var mobile: Mobile? { return creature as? Mobile }
    var world: World { return creature.world }
    var room: Room? { return creature.room }
    var area: Area? { return areaInstance?.area }
    var areaInstance: AreaInstance? { return room?.areaInstance }

    public init(args: Scanner, creature: Creature, session: Session, userCommand: String) {
        self.args = args
        self.creature = creature
        self.session = session
        self.userCommand = userCommand
    }
    
    func argument(type: GameObjectType, optional: Bool = false) -> GameObject {
        if type.contains(.room) {
            if case .room(let room) = scanRoomArgument(optional: optional) {
                return .room(room)
            }
        }
        if type.contains(.areaInstance) {
            if case .areaInstance(let areaInstance) = scanAreaInstanceArgument(optional: optional) {
                return .areaInstance(areaInstance)
            }
        }
        send("Nothing found.")
        return .none
    }
    
    func send(_ items: Any..., separator: String = "", terminator: String = "\n") {
        // TODO: send text to all player's sessions, not only this specific one
        // TODO: use creature.send()
        session.send(items: items, separator: separator, terminator: terminator)
    }
}
