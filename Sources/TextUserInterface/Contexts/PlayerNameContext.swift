//
// PlayerNameContext.swift
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

final class PlayerNameContext: SessionContext {
    static var name = "playerName"
    
    func greet(session: Session) {
        defer { session.sendPrompt("Please choose a name for your character: ") }
        
        guard let accountId = session.account?.accountId else { return }
        let players = Player.with(accountId: accountId)
        let playerNames = players.map { v in v.name }.sorted()
        guard !playerNames.isEmpty else { return }
        
        session.send("Your characters:  ")
        for (index, name) in playerNames.sorted().enumerated() {
            session.send("  \(index + 1). \(name)")
        }
    }

    func processResponse(args: Arguments, session: Session) throws -> ContextAction {
        guard let lowercasedName = args.scanWord()?.lowercased() else {
            return .retry(reason: nil)
        }
        
        let badCharacters = Config.playerNameAllowedCharacters.inverted
        guard lowercasedName.rangeOfCharacter(from: badCharacters) == nil else {
            return .retry(reason: Config.playerNameInvalidCharactersMessage)
        }
        
        let name = lowercasedName.capitalized
        let nameLength = name.characters.count
        guard nameLength >= Config.playerNameLength.lowerBound else {
            return .retry(reason: "Character name is too short")
        }
        guard nameLength <= Config.playerNameLength.upperBound else {
            return .retry(reason: "Character name is too long")
        }
        
        if let player = Player.with(name: name) {
            guard player.account == session.account else {
                return .retry(reason: "Character named '\(name)' already exists. Please choose a different name.")
            }
            session.player = player
        } else {
            guard let account = session.account else {
                return .next(context: ChooseAccountContext())
            }
            
            let player = Player()
            player.account = account
            player.name = name
            player.modified = true
            Player.addToIndexes(player: player)
            session.player = player
        }
        
        return .next(context: MainMenuContext())
    }
}
