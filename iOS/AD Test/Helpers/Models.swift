//
//  Models.swift
//  AD Test
//
//  Created by Dava Tech Group, Inc.
//

import Foundation

struct Open: Codable {
    let sessionToken: String?
    let authenticationToken: String?
    let result: Int
    enum CodingKeys: String, CodingKey {
        case sessionToken = "session_token"
        case authenticationToken = "authentication_token"
        case result = "result"
    }
}

struct OpenResponse: Codable, CustomStringConvertible {
    var description: String {
        return """
            {
             "open" : {
              "result" : \(open.result),
              "session_token" : \(open.sessionToken ?? "nil"),
              "authentication_token" : \(open.authenticationToken ?? "nil")
             }
            }
            """
    }
    let open: Open
    enum CodingKeys: String, CodingKey {
        case open = "open"
    }
}

struct NewDeviceResponse: Codable, CustomStringConvertible {
    var description: String {
        return """
            {
             "newdevice" : {
              "result" : \(newDevice.result),
              "session_token" : \(newDevice.sessionToken ?? "nil"),
              "authentication_token" : \(newDevice.authenticationToken ?? "nil")
             }
            }
            """
    }
    let newDevice: Open
    enum CodingKeys: String, CodingKey {
        case newDevice = "newdevice"
    }
}

struct Verify: Codable {
    let result: Int
    let device: String?
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
        case device = "device"
    }
}

struct VerifyResponse: Codable, CustomStringConvertible {
    var description: String {
        return """
            {
             "verify" : {
              "result" : \(verify.result),
              "device" : \(verify.device ?? "nil")
             }
            }
            """
    }
    let verify:Verify
    enum CodingKeys: String, CodingKey {
        case verify = "verify"
    }
}

struct List: Codable {
    let devices: [String:Bool]?
    let result:Int
    
    enum CodingKeys: String, CodingKey {
        case devices = "devices"
        case result = "result"
    }
}

struct ListResponse: Codable, CustomStringConvertible {
    var description: String {
        var devices = ""
        for (name, enabled) in device.devices ?? [:] {
            devices+="""
            "\(name)" : \(enabled),
            """
        }
        return """
            {
             "device" : {
              "devices" : {
                \(devices.dropLast())
              },
             "result" : \(device.result)
             }
            }
            """
    }
    let device:List
    enum CodingKeys: String, CodingKey {
        case device = "device"
    }
}


