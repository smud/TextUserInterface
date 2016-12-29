//
// CommandRouter.swift
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

public class CommandRouter {
    public typealias Handler = (_ context: CommandContext) throws -> CommandAction
    typealias Path = (command: Command, handler: Handler)
    typealias UnknownCommandHandler = (_ context: CommandContext) -> ()
    typealias PartialMatchHandler = (_ context: CommandContext) -> ()
    
    var paths = [Path]()

    func add(_ command: Command, _ handler: @escaping Handler) {
        paths.append(Path(command, handler))
    }
    
    func add(_ commandString: String, _ options: Command.Options = [], _ handler: @escaping Handler) {
        add(Command(commandString, options: options), handler)
    }
    
    subscript(_ command: Command) -> Handler {
        get { fatalError("Not implemented") }
        set { add(command, newValue) }
    }
    
    public subscript(_ commandString: String, _ options: Command.Options) -> Handler {
        get { fatalError("Not implemented") }
        set { add(Command(commandString, options: options), newValue) }
    }
    
    public subscript(_ commandString: String) -> Handler {
        get { fatalError("Not implemented") }
        set { add(Command(commandString), newValue) }
    }


    func process(args: Scanner, player: Player, session: Session, unknownCommand: UnknownCommandHandler, partialMatch: PartialMatchHandler) {
        
        let originalScanLocation = args.scanLocation
        for path in paths {
            if let userCommand = path.command.fetchFrom(args) {
                let context = CommandContext(args: args, creature: player, session: session, userCommand: userCommand)
                do {
                    switch try path.handler(context) {
                    case .accept:
                        if !args.isAtEnd {
                            partialMatch(context)
                        }
                        return
                    case .showUsage(let text):
                        context.send(text)
                        return
                    case .next:
                        break
                    }
                } catch {
                    context.send("An error has occured while processing the command.")
                    print("While processing '\(path.command.name)': \(error)")
                    return
                }
            }
            args.scanLocation = originalScanLocation
        }
        let context = CommandContext(args: args, creature: player, session: session, userCommand: "")
        unknownCommand(context)
    }
}
