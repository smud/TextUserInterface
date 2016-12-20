//
// SessionContext.swift
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

public protocol SessionContext {
    static var name: String { get }
    
    init()
    
    func greet(session: Session)
    func processResponse(args: Arguments, session: Session) throws -> ContextAction
}

func ==(lhs: SessionContext, rhs: SessionContext) -> Bool {
    return type(of: lhs).name == type(of: rhs).name
}

func !=(lhs: SessionContext, rhs: SessionContext) -> Bool {
    return type(of: lhs).name != type(of: rhs).name
}
