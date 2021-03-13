//
//  main.swift
//  ligo
//
//  Created by Stephen Dunne on 3/9/21.
//

import Foundation
import Virtualization

// hardcoding all of these for now, but they should be cli flags
let linuxKernel: URL = URL(fileURLWithPath: CommandLine.arguments[1])
let linuxInitrd: URL = URL(fileURLWithPath: CommandLine.arguments[2])

let kernelArguments: String = "console=hvc0"
let cpus: Int = 1
let memory: UInt64 = 1073741824 // this is in bytes 512M: 536870912, 1G: 1073741824, 2G: 2147483648

// Create a dispatch queue to manage the vm(s)
let ligoVMQueue = DispatchQueue(label: "com.ligo.vm-queue")

// Create our configuration
let guestConfig = LigoVM.Config(guestKernel: linuxKernel, guestRamdisk: linuxInitrd, guestKernelArguments: kernelArguments, guestCpus: cpus, guestMemory: memory)

// Create our console
let guestConsole = LigoConsole(readHandle: FileHandle.standardOutput, writeHandle: FileHandle.standardInput)

// Create our VM
let ligoVM = LigoVM(guestConsole: guestConsole, guestConfig: guestConfig, queue: ligoVMQueue)

// Attempt to start the VM
ligoVMQueue.sync {
    ligoVM.virtualGuest.start { result in
        switch result {
        case .success:
            print("VM Started Successfully!")
        case .failure:
            print("VM Failed to Start!")
            print(result)
        }
    }
}

// refactor to something better maybe
while ligoVM.virtualGuest.state == .running || ligoVM.virtualGuest.state == .starting {
    sleep(1)
}
