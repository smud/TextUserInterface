//
// AdminCommands.swift
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

class AdminCommands {
    func register(with router: CommandRouter) {
        router["area list"] = areaList
        router["area"] = area
        
        router["room list"] = roomList
        router["room"] = room
    }
    
    func areaList(context: CommandContext) -> CommandAction {
        context.send("List of areas:")
        let areas = context.world.areasById.sorted { lhs, rhs in
            lhs.value.title.caseInsensitiveCompare(rhs.value.title) == .orderedAscending }
        let areaList = areas.map { v in "  #\(v.value.id) \(v.value.title)" }.joined(separator: "\n")
        context.send(areaList.isEmpty ? "  none." : areaList)
        return .accept
    }
    
    func area(context: CommandContext) -> CommandAction {
        var result = ""
        if let subcommand = context.args.scanWord() {
            result += "Unknown subcommand: \(subcommand)\n"
        }
        result += "Available subcommands: delete, list, new, rename"
        return .showUsage(result)
    }

    func roomList(context: CommandContext) throws -> CommandAction {
        guard let areaInstance = context.scanAreaInstance(optional: true) else { return .accept }
        
        context.send("List of #\(areaInstance.area.id):\(areaInstance.index) rooms:")
        let rooms = areaInstance.roomsById.values
            .sorted { $0.id < $1.id }
            .map { return "  #\($0.id) \($0.title)" }
            .joined(separator: "\n")
        context.send(rooms.isEmpty ? "  none." : rooms)
        return .accept
    }
    
    func room(context: CommandContext) -> CommandAction {
        var result = ""
        if let subcommand = context.args.scanWord() {
            result += "Unknown subcommand: \(subcommand)\n"
        }
        result += "Available subcommands: delete, list, new, rename"
        return .showUsage(result)
    }
}
