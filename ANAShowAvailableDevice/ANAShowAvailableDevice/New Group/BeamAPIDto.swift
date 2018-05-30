//
//  BeamAPIDto.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/24.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let emailAddress : String
    let isTemporary: Bool 
}

struct TemporaryAccess: Codable {
    let objects: [TempUserInfo]
}

struct TempUserInfo: Codable {
    let emailAddress : String
    let deviceGroup : Int
}

struct PermanentAccess: Codable {
    let objects: [TempUserInfo]
}

struct PermUserInfo: Codable {
    let user : String
    let deviceGroup : Int
}

struct DeviceGroupInfo: Codable {
    let id: String
    let devices: [String]
}

struct DeviceInfo: Codable {
    let name : String
    let deviceTypeName : String
    let id : String
    let timeZone : String
    let state : DeviceState
}

struct DeviceState: Codable {
    let callState : String
}

struct DeviceGroupMembership: Codable {
    let objects: [MembershipInfo]
}

struct MembershipInfo: Codable {
    let accessTimes : [String]
    let deviceGroup: Int
    let user: String
    //let userGroup: MembershipUserGroup
}

struct MembershipUserGroup: Codable {
    let users = [""]
}
struct DefaultAccessTime: Codable {
    let objects: [DefaultAccessTimeOfDeviceGroup]
}

struct DefaultAccessTimeOfDeviceGroup: Codable {
    
    let deviceGroup : Int
    // if response of end time or start time is null, cant parse anything
    let endTime = ""
    let startTime = ""
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    let sunday: Bool
    
}
