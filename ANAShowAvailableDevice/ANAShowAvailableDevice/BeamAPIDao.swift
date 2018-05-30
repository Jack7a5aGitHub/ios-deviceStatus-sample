//
//  BeamAPIDao.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/24.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation
import Alamofire

//API Status
enum FetchAPIStatus {
    case loading
    case loaded([DeviceInfo])
    case timeout
    case offline
    case error(message:String)
}

protocol FetchResult: class {
    func set(status: FetchAPIStatus)
}

final class BeamAPIDao {
    
    //MARK: -Properties
    weak var result: FetchResult?
    private let baseURLString = "https://suitabletech.com/admin-api/1"
    private let headers: HTTPHeaders = ["Authorization": "APIKEY:hOmZ9x5QrMFa:cmUCJ0xm0lEQQTDy36EURf3YHOXqOeCtbnv8VO1THd36"]
    private var loginEmail = ""
    var deviceGroups = [Int]()
    private var devices = [String]()
    var allDevices = [DeviceInfo]()
    var isTemp = false
    //MARK: -func
    func fetchUserData(email: String!){
        result?.set(status: .loading)
        let path = baseURLString + "/users/\(email!)/"
        print("Path: \(path)")
        let url = URL(string: path)!
        Alamofire.request(url,headers: headers).responseString { (response) in
            
            guard let json = response.data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let user = try decoder.decode(UserInfo.self, from: json)
                self.loginEmail = user.emailAddress
                self.isTemp = user.isTemporary
                self.fetchDeviceGroupID(isTemp: user.isTemporary){
                    print("I Got the Device groups for specific Email")
                    switch self.deviceGroups.count {
                    case 1:
                        self.fetchDeviceIds(deviceGroupIds: self.deviceGroups[0]){
                            for device in self.devices {
                                
                                self.fetchDeviceDetails(deviceID: device)
                            }
                            self.fetchAccessTime(isTempUser: user.isTemporary)
                            print("Device Ids Gotcha")
                        }
                        print("Only exist in one device group")
                    case 0:
                        print("Dont exist in any device group!")
                        break
                    default:
                        print("User exists in more than one device group")
                        break
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDeviceGroupID(isTemp: Bool, completionHandler: @escaping () -> Void ){
        if isTemp {
            let path = baseURLString + "/temporary-access/"
            print("Path: \(path)")
            let url = URL(string: path)!
            Alamofire.request(url,headers: headers).responseString { (response) in
                
                guard let json = response.data else { return }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let tempAccess = try decoder.decode(TemporaryAccess.self, from: json)
                    let tempUserInfo = tempAccess.objects
                    for user in tempUserInfo where user.emailAddress == self.loginEmail{
                        self.deviceGroups.append(user.deviceGroup)
                        print("Filtered \(self.deviceGroups)")
                    }
                    completionHandler()
                } catch {
                    print(error.localizedDescription)
                }
            }
        } else {
            print("You Are Permanent User LOL !")
            let path = baseURLString + "/device-group-memberships/"
            print("Path: \(path)")
            let url = URL(string: path)!
            Alamofire.request(url,headers: headers).responseString { (response) in
                
                guard let json = response.data else { return }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    let tempAccess = try decoder.decode(TemporaryAccess.self, from: json)
                    let tempUserInfo = tempAccess.objects
                    for user in tempUserInfo where user.emailAddress == self.loginEmail{
                        self.deviceGroups.append(user.deviceGroup)
                        print("Filtered \(self.deviceGroups)")
                    }
                    completionHandler()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    func fetchDeviceIds(deviceGroupIds: Int, completionHandler: @escaping () -> Void ){
        
        let path = baseURLString + "/device-groups/\(deviceGroupIds)/"
        print("Path: \(path)")
        let url = URL(string: path)!
        Alamofire.request(url,headers: headers).responseString { (response) in
            
            guard let json = response.data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let deviceGroupInfo = try decoder.decode(DeviceGroupInfo.self, from: json)
                let devicesId = deviceGroupInfo.devices
                for device in devicesId {
                    self.devices.append(device)
                    print("Devices \(self.devices)")
                }
                completionHandler()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func fetchDeviceDetails(deviceID: String!){
        let path = baseURLString + "/devices/\(deviceID!)/"
        print("Path: \(path)")
        let url = URL(string: path)!
        Alamofire.request(url,headers: headers).responseString { (response) in
            
            guard let json = response.data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let deviceInfo = try decoder.decode(DeviceInfo.self, from: json)
                
                print("Device Info: \(deviceInfo)")
                self.allDevices.append(deviceInfo)
                print("ALL : \(self.allDevices)")
                
                self.result?.set(status: .loaded(self.allDevices))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchAccessTime(isTempUser: Bool){
        if !isTempUser {
            fetchDGMInfo()
        }
        fetchDefaultAccessTime()
        
    }
    func fetchDGMInfo(){
        let path = baseURLString + "/device-group-memberships/"
        print("Path: \(path)")
        let url = URL(string: path)!
        Alamofire.request(url,headers: headers).responseString { (response) in
            
            guard let json = response.data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let deviceGroupMembershipInfo = try decoder.decode(DeviceGroupMembership.self, from: json)
                let membershipInfo = deviceGroupMembershipInfo.objects
                print(membershipInfo)
                for member in membershipInfo where self.loginEmail == member.user {
                    print(member.accessTimes)
                    if !member.accessTimes.isEmpty {
                        self.fetchAccessTimeList()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func fetchDefaultAccessTime(){
        let path = baseURLString + "/default-access-times/"
        print("Path: \(path)")
        let url = URL(string: path)!
        Alamofire.request(url,headers: headers).responseString { (response) in
            
            guard let json = response.data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let defaultAccessTimeInfo = try decoder.decode(DefaultAccessTime.self, from: json)
                print("DefaultAccessTimeInfo : \(defaultAccessTimeInfo.objects)")
                let defaultTime = defaultAccessTimeInfo.objects
                for time in defaultTime where self.deviceGroups[0] == time.deviceGroup {
                    print(" My Device group open time \(time)")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    func fetchAccessTimeList(){
        print("get access time list")
    }
}
