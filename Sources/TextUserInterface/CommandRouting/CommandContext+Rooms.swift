//
// CommandContext+Rooms.swift
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

extension CommandContext {
    public enum RoomArgument: CustomStringConvertible {
        case room(Room)
        case linkExpected
        case areaDoesNotExist(areaId: String)
        case noAreaId
        case instanceDoesNotExist(instance: Int)
        case roomDoesNotExist(link: Link)
        case areaHasNoInstances
        case areaInstanceHasNoRooms

        public var description: String {
            switch self {
            case .room(let room): return "Room #\(room.id)"
            case .linkExpected: return "Link expected."
            case .areaDoesNotExist(let areaId): return "Area #\(areaId) does not exist."
            case .noAreaId: return "Area id not specified and you aren't standing in any room."
            case .instanceDoesNotExist(let instance): return "Instance \(instance) does not exist."
            case .roomDoesNotExist(let link): return "Room \(link) does not exist."
            case .areaHasNoInstances: return "Area has no instances."
            case .areaInstanceHasNoRooms: return "Area instance has no rooms."
            }
        }
    }
    
    public func scanRoom(optional: Bool = false) -> Room? {
        let arg: RoomArgument = scanRoomArgument(optional: optional)
        switch arg {
        case .room(let room): return room
        default:
            send(arg.description)
            return nil
        }
    }
    
    public func scanRoomArgument(optional: Bool) -> RoomArgument {
        if let link = args.scanLink() {
            let areaInstance: AreaInstance

            if let areaId = link.parent {
                guard let area = world.areasById[areaId] else {
                    return .areaDoesNotExist(areaId: areaId)
                }
                
                if let instanceIndex = link.instance {
                    guard let v = area.instancesByIndex[instanceIndex] else {
                        return .instanceDoesNotExist(instance: instanceIndex)
                    }
                    areaInstance = v
                } else {
                    guard let v = area.instancesByIndex.first?.value else {
                        return .areaHasNoInstances
                    }
                    areaInstance = v
                }
            } else {
                guard let v = self.areaInstance else {
                    return .noAreaId
                }
                areaInstance = v
            }

            guard let room = areaInstance.roomsById[link.object] else {
                return .roomDoesNotExist(link: link)
            }
            return .room(room)
        } else if !optional {
            return .linkExpected
        } else {
            guard let areaInstance = self.areaInstance else {
                return .noAreaId
            }
            guard let room = areaInstance.roomsById.first?.value else {
                return .areaInstanceHasNoRooms
            }
            return .room(room)
        }
    }
}
