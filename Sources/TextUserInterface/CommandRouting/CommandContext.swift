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
        static let creature = GameObjectType(rawValue: 1 << 2)
    }
    
    enum GameObject {
        case none
        case areaInstance(AreaInstance)
        case room(Room)
        case creature(Creature)
    }
    
    let args: Scanner
    var hasArgs: Bool { return !args.isAtEnd }
    
    let creature: Creature
    let session: Session
    let userCommand: String

    // Too easy to use accidentally instead of creature,
    // it's better to cast explicitly where player
    // or mobile are really needed.
    //var player: Player? { return creature as? Player }
    //var mobile: Mobile? { return creature as? Mobile }
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
    
    func scanArgument(type: GameObjectType, optional: Bool = false) -> GameObject {
        let originalScanLocation = args.scanLocation
        
        /*
        if type.contains(.creature) {
            if case .creature(let creature) = scanCreatureArgument(optional: optional) {
                return .creature(creature)
            }
        }
        */

        if type.contains(.room) {
            if case .room(let room) = scanRoomArgument(optional: optional) {
                return .room(room)
            }
        }
        args.scanLocation = originalScanLocation
        
        if type.contains(.areaInstance) {
            if case .areaInstance(let areaInstance) = scanAreaInstanceArgument(optional: optional) {
                return .areaInstance(areaInstance)
            }
        }
        args.scanLocation = originalScanLocation
        
        send("Nothing found by this name.")
        
        args.skipWord()
        return .none
    }
    
    func send(_ items: Any..., separator: String = "", terminator: String = "\n") {
        creature.send(items: items, separator: separator, terminator: terminator)
    }
}
