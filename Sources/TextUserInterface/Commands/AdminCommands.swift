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
import Smud

class AdminCommands {
    func register(with router: CommandRouter) {
        router["area list"] = areaList
        router["area edit"] = areaEdit
        router["area save"] = areaSave
        router["area"] = area
        
        router["room list"] = roomList
        router["room info"] = roomInfo
        router["room"] = room

        router["dig north"] = { return self.dig(.north, $0) }
        router["dig east"] = { return self.dig(.east, $0) }
        router["dig south"] = { return self.dig(.south, $0) }
        router["dig west"] = { return self.dig(.west, $0) }
        router["dig up"] = { return self.dig(.up, $0) }
        router["dig down"] = { return self.dig(.down, $0) }
        router["dig"] = dig
    }
    
    func areaList(context: CommandContext) -> CommandAction {
        context.send("List of areas:")
        let areas = context.world.areasById.sorted { lhs, rhs in
            lhs.value.title.caseInsensitiveCompare(rhs.value.title) == .orderedAscending }
        let areaList = areas.map { v in "  #\(v.value.id) \(v.value.title)" }.joined(separator: "\n")
        context.send(areaList.isEmpty ? "  none." : areaList)
        return .accept
    }

    func areaEdit(context: CommandContext) -> CommandAction {
        guard let currentRoom = context.creature.room else {
            context.send("You are not standing in any area.")
            return .accept
        }

        let newInstance = currentRoom.areaInstance.area.createInstance(mode: .forEditing)
        newInstance.buildMap()

        let room: Room
        if let previousRoom = newInstance.roomsById[currentRoom.id] {
            room = previousRoom
        } else {
            context.send("Can't find you current room in newly created instance. Probably it has been removed. Relocating to area's default room")
            guard let defaultRoom = newInstance.roomsById.values.first else {
                context.send("Area \(newInstance.area.id) is empty")
                newInstance.area.removeInstance(newInstance)
                return .accept
            }
            room = defaultRoom
        }

        context.creature.room = room

        context.send("Relocated to \(Link(room: currentRoom)) (editing mode)")
        context.creature.look()
        return .accept
    }
    
    func areaSave(context: CommandContext) -> CommandAction {
        guard let area = context.area else {
            context.send("You aren't standing in any area.")
            return .accept
        }
        area.scheduleForSaving()
        context.send("Area #\(area.id) scheduled for saving.")
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

    func roomInfo(context: CommandContext) -> CommandAction {
        let room: Room
        if let link = context.args.scanLink() {
            guard let resolvedRoom = context.world.resolveRoom(link: link, defaultInstance: context.creature.room?.areaInstance) else {
                context.send("Cant find room \(link)")
                return .accept
            }
            room = resolvedRoom
        } else {
            guard let currentRoom = context.creature.room else {
                context.send("You are not standing in any room.")
                return .accept
            }

            if let directionWord = context.args.scanWord() {
                guard let direction = Direction(rawValue: directionWord) else {
                    context.send("Expected link or direction.")
                    return .accept
                }
                guard let neighborLink = currentRoom.exits[direction] else {
                    context.send("There's no room in that direction from you.")
                    return .accept
                }
                guard let neighborRoom = currentRoom.resolveLink(link: neighborLink) else {
                    context.send("Can't find neighbor room.")
                    return .accept
                }

                room = neighborRoom
            } else {
                room = currentRoom
            }
        }

        var fields = [(title: String, content: String)]()
        fields.append((title: "Link", content: "\(Link(room: room))"))
        for direction in Direction.orderedDirections {
            let directionName = direction.rawValue.capitalizingFirstLetter()
            let directionLink = room.exits[direction]?.description ?? "none"
            fields.append((title: directionName, content: directionLink))
        }

        context.send(fields.map{ "\($0.title): \($0.content)" }.joined(separator: "\n"))
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

    func dig(_ direction: Direction, _ context: CommandContext) -> CommandAction {
        return dig(direction: direction, context: context)
    }

    func dig(direction: Direction, context: CommandContext) -> CommandAction {
        guard let currentRoom = context.creature.room else {
            context.send("You are not standing in any room, there's nowhere to dig.")
            return .accept
        }

        guard currentRoom.areaInstance.resetMode == .forEditing else {
            context.send("Please enter \"area edit\" to start editing.")
            return .accept
        }

        guard let roomId = context.args.scanWord() else {
            context.send("Expected room identifier.")
            return .accept
        }

        guard let destinationRoom = currentRoom.areaInstance.digRoom(from: currentRoom, direction: direction, id: roomId) else {
            context.send("Failed to dig room.")
            return .accept
        }

        context.creature.room = destinationRoom
        context.creature.look()

        return .accept
    }

    func dig(context: CommandContext) -> CommandAction {
        var result = ""
        if let subcommand = context.args.scanWord() {
            result += "Unknown subcommand: \(subcommand)\n"
        }

        result += "Available subcommands:\n"
        result += "    north <room id>\n";
        result += "    south <room id>\n";
        result += "    east <room id>\n";
        result += "    west <room id>\n";
        result += "    up <room id>\n";
        result += "    down <room id>";
        return .showUsage(result)
    }
}
