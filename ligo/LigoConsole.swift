//
//  LigoConsole.swift
//  ligo
//
//  Created by Stephen Dunne on 3/12/21.
//

import Foundation
import Virtualization

// todo: actually create a console socket/pipe/something to bind a serial terminal to, since stdin/out isn't great
struct LigoConsole {
    var readHandle: FileHandle
    var writeHandle: FileHandle
}
