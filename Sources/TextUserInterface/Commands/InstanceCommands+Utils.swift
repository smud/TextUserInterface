//
// InstanceCommands+Utils.swift
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

extension InstanceCommands {
    func area(link: Link?, context: CommandContext) -> Area? {
        if let link = link {
            if link.isQualified {
                context.send("Expected area id only: #areaname")
                return nil
            }

            guard let v = context.world.areasById[link.entity] else {
                context.send("Area \(link) does not exist.")
                return nil
            }
            return v

        } else if let v = context.area {
            return v

        } else {
            context.send("No area id specified and you aren't standing in any room.")
            return nil
        }
    }

}
