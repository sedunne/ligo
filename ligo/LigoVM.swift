//
//  LigoVM.swift
//  ligo
//
//  Created by Stephen Dunne on 3/12/21.
//

import Foundation
import Virtualization

// main LigoVM type
struct LigoVM: Identifiable {
    let id: UUID
    let virtualGuest: VZVirtualMachine
    let guestConsole: LigoConsole
    var guestConfig: LigoVM.Config
    var queue: DispatchQueue
    
    init(id: UUID = UUID(), guestConsole: LigoConsole, guestConfig: LigoVM.Config, queue: DispatchQueue) {
        self.id = id
        self.guestConsole = guestConsole
        self.guestConfig = guestConfig
        self.queue = queue
        
        let guestBootloader = VZLinuxBootLoader(kernelURL: guestConfig.guestKernel)
        guestBootloader.commandLine = guestConfig.guestKernelArguments
        guestBootloader.initialRamdiskURL = guestConfig.guestRamdisk

        // Create our Memory baloon device
        let guestMemBaloon = VZVirtioTraditionalMemoryBalloonDeviceConfiguration()

        // Manage serial connection
        let guestSerialPort = VZVirtioConsoleDeviceSerialPortConfiguration()
        // this is confusing b/c the parameter names are from the guest's perspective, so "read" to the guest translates to "write" from the host
        guestSerialPort.attachment = VZFileHandleSerialPortAttachment(fileHandleForReading: guestConsole.writeHandle,
                                                                      fileHandleForWriting: guestConsole.readHandle)

        // Setup rng
        let guestRandom = VZVirtioEntropyDeviceConfiguration()

        // Create the VM configuration
        let guestVMConfig = VZVirtualMachineConfiguration()
        guestVMConfig.bootLoader = guestBootloader
        guestVMConfig.entropyDevices = [guestRandom]
        guestVMConfig.cpuCount = guestConfig.guestCpus
        guestVMConfig.serialPorts = [guestSerialPort]
        guestVMConfig.memorySize = guestConfig.guestMemory
        guestVMConfig.memoryBalloonDevices = [guestMemBaloon]
        
        // Validate the configuration
        do {
            try guestVMConfig.validate()
            print("VM Configuration Passed!")
        }
        catch {
            print("VM Configuration Failed!")
            exit(1)
        }
        
        self.virtualGuest = VZVirtualMachine(configuration: guestVMConfig, queue: self.queue)
    }
}

// LigoVM configuration type
extension LigoVM {
    struct Config {
        let guestKernel: URL
        let guestRamdisk: URL
        let guestKernelArguments: String
        let guestCpus: Int
        let guestMemory: UInt64
    }
}
