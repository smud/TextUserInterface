//
// AreaInstanceData.swift
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

class AreaInstanceData: PluginData {
    typealias Parent = AreaInstance
    lazy var renderedAreaMap: RenderedAreaMap? = {
        guard let areaMap = self.parent?.areaMap else { return nil }
        return RenderedAreaMap(areaMap: areaMap)
    }()
    
    weak var parent: Parent?
    
    required init(parent: Parent) {
        self.parent = parent
    }
}
