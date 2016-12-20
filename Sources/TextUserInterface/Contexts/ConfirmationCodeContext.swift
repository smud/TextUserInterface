//
// ConfirmationCodeContext.swift
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

final class ConfirmationCodeContext: SessionContext {
    static var name = "confirmationCode"
    
    func greet(session: Session) {
        session.sendPrompt("Please enter the confirmation code: ")
    }
    
    func processResponse(args: Arguments, session: Session) -> ContextAction {
        guard let code = args.scanWord(), code == "123" else {
            return .retry(reason: "Ivalid confirmation code.")
        }
        
        session.send("Your account has been succesfully created.")
        
        return .next(context: PlayerNameContext())
    }
}
