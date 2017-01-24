//
// CommandContext+Areas.swift
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
    public enum AreaInstanceArgument: CustomStringConvertible {
        case areaInstance(AreaInstance)
        case linkExpected
        case areaDoesNotExist(areaId: String)
        case noAreaId
        case instanceDoesNotExist(instance: Int)
        case areaHasNoInstances

        public var description: String {
            switch self {
            case .areaInstance(let areaInstance): return "Area instance #\(areaInstance.area.id):\(areaInstance.index)"
            case .linkExpected: return "Link expected."
            case .areaDoesNotExist(let areaId): return "Area #\(areaId) does not exist."
                
            case .noAreaId: return "Area id not specified and you aren't standing in any room."
            case .instanceDoesNotExist(let instance): return "Instance \(instance) does not exist."
            case .areaHasNoInstances: return "Area has no instances."
            }
        }
    }
    
    public func scanAreaInstance(optional: Bool = false) -> AreaInstance? {
        let arg: AreaInstanceArgument = scanAreaInstanceArgument(optional: optional)
        switch arg {
        case .areaInstance(let areaInstance): return areaInstance
        default:
            send(arg.description)
            return nil
        }
    }
    
    public func scanAreaInstanceArgument(optional: Bool) -> AreaInstanceArgument {
        if let link = args.scanLink() {
            let areaId = link.object
            guard let area = world.areasById[areaId] else {
                return .areaDoesNotExist(areaId: areaId)
            }
            
            if let instanceIndex = link.instance {
                guard let areaInstance = area.instancesByIndex[instanceIndex] else {
                    return .instanceDoesNotExist(instance: instanceIndex)
                }
                return .areaInstance(areaInstance)
            } else {
                guard let areaInstance = area.instancesByIndex.first?.value else {
                    return .areaHasNoInstances
                }
                return .areaInstance(areaInstance)
            }
        } else if !optional {
            return .linkExpected
        } else if let areaInstance = areaInstance {
            return .areaInstance(areaInstance)
        } else {
            return .noAreaId
        }
    }
}
