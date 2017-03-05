//
// InstanceCommands.swift
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

class InstanceCommands {
    func register(with router: CommandRouter) {
        router["instance list"] = instanceList
        router["instance new edit"] = { try self.instanceNew(mode: .forEditing, context: $0) }
        router["instance new"] = { try self.instanceNew(mode: .forPlaying, context: $0) }
        router["instance"] = instance
    }

    func instanceList(context: CommandContext) -> CommandAction {
        let link = context.args.scanLink()
        
        guard let area = area(link: link, context: context) else {
            return .accept
        }

        context.send("List of #\(area.id) instances:")
        let instances = area.instancesByIndex.keys
            .sorted()
            .map { String($0) }
            .joined(separator: ", ")
        context.send(instances.isEmpty ? "  none." : instances)

        return .accept
    }
    
    func instanceNew(mode: AreaInstance.ResetMode, context: CommandContext) throws -> CommandAction {
        guard let link = context.args.scanLink(), link.areaId == nil else {
            return .showUsage("Usage: instance new #area:instance\n" +
                "Instance number is optional.")
        }
        let areaId = link.entityId

        guard let area = context.world.areasById[areaId] else {
            context.send("Area #\(areaId) does not exist.")
            return .accept
        }

        switch area.createInstance(withIndex: link.instanceIndex, mode: mode) {
        case .ok(let instance):
            instance.buildMap()
            context.send("Instance #\(areaId):\(instance.index) created.")
        case .instanceAlreadyExists(_):
            context.send("Instance \(link) already exists.")
        }

        return .accept
    }
    
    func instance(context: CommandContext) -> CommandAction {
        var result = ""
        if let subcommand = context.args.scanWord() {
            result += "Unknown subcommand: \(subcommand)\n"
        }
        result += "Available subcommands: \n"
        result += "    list\n"
        result += "    new\n"
        return .showUsage(result)
    }
}
