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
    let args: Scanner
    var hasArgs: Bool { return !args.string.isEmpty }
    
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

    public enum RoomArgument: CustomStringConvertible {
        case room(Room)
        case linkExpected
        case areaDoesNotExist(areaId: String)
        case noAreaId
        case noInstanceIndex
        case instanceDoesNotExist(instance: Int)
        case roomDoesNotExist(link: Link)
        
        public var description: String {
            switch self {
            case .room(let room): return "Room #\(room.id)"
            case .linkExpected: return "Link expected"
            case .areaDoesNotExist(let areaId): return "Area #\(areaId) does not exist."
            case .noAreaId: return "Area id not specified and you aren't standing in any room."
            case .noInstanceIndex: return "Please specify an instance index."
            case .instanceDoesNotExist(let instance): return "Instance \(instance) does not exist."
            case .roomDoesNotExist(let link): return "Room \(link) does not exist."
            }
        }
    }
    
    public func scanRoom() -> Room? {
        let arg: RoomArgument = scanRoomArgument()
        switch arg {
        case .room(let room): return room
        default:
            send(arg.description)
            return nil
        }
    }
    
    public func scanRoomArgument() -> RoomArgument {
        guard let link = args.scanLink() else {
            return .linkExpected
        }
        
        var targetArea: Area
        if let areaId = link.parent {
            guard let v = world.areasById[areaId] else {
                return .areaDoesNotExist(areaId: areaId)
            }
            targetArea = v
        } else if let v = area {
            targetArea = v
        } else {
            return .noAreaId
        }
        
        var targetInstance: Int
        if let instanceIndex = link.instance {
            targetInstance = instanceIndex
        } else if let v = room?.areaInstance.index {
            targetInstance = v
        } else {
            return .noInstanceIndex
        }
        
        guard let instance = targetArea.instances[targetInstance] else {
            return .instanceDoesNotExist(instance: targetInstance)
        }
        
        guard let room = instance.roomsById[link.object] else {
            return .roomDoesNotExist(link: link)
        }
        
        return .room(room)
    }
    
    func send(_ items: Any..., separator: String = "", terminator: String = "\n") {
        // TODO: send text to all player's sessions, not only this specific one
        // TODO: use creature.send()
        session.send(items: items, separator: separator, terminator: terminator)
    }
}
