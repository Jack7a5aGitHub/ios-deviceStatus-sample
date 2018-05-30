//
//  AvailableDevicesViewController.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/24.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

final class AvailableDevicesViewController: UIViewController {
    
    // MARK: - Factory
    class func make(with emailAddress: String) -> AvailableDevicesViewController {
        let vcName = AvailableDevicesViewController.className
        guard let availableDevicesVC = UIStoryboard.viewController(storyboardName: vcName, identifier: vcName) as? AvailableDevicesViewController else {
            fatalError("availableDevicesVC is nil")
        }
        availableDevicesVC.loggedInEmailAddress = emailAddress
        return availableDevicesVC
    }
    
    //MARK: -Properties
    private var loggedInEmailAddress = ""
    private let beamAPIDao = BeamAPIDao()
    private let availableDevicesProvider = AvailableDevicesProvider()
    private var myDeviceGroup = [Int]()
    private var myIsTemp = false
    //MARK: -IBOutlet
    @IBOutlet weak var availableDevicesTableView: UITableView!
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        registerNib()
    }

}

//MARK: -private func
extension AvailableDevicesViewController {
    
    private func setupTableView(){
        availableDevicesTableView.delegate = self
        availableDevicesTableView.dataSource = availableDevicesProvider
        beamAPIDao.result = self
        print("Received email: \(loggedInEmailAddress)")
        beamAPIDao.fetchUserData(email: loggedInEmailAddress)
    }
    private func registerNib(){
        availableDevicesTableView.register(UINib(nibName: AvailableDevicesTableViewCell.className, bundle: nil), forCellReuseIdentifier: AvailableDevicesTableViewCell.className)
    }
   
}

//MARK: - FetchResultDelegate
extension AvailableDevicesViewController: FetchResult {
    func set(status: FetchAPIStatus) {
        switch status {
            
        case .loading:
            break
        case .loaded(let response):
            availableDevicesProvider.set(items: response)
            myDeviceGroup = beamAPIDao.deviceGroups
            myIsTemp = beamAPIDao.isTemp
            print("what deivce group i belong to: \(myDeviceGroup)")
            availableDevicesTableView.reloadData()
        case .timeout:
            break
        case .offline:
            break
        case .error(let message):
            print(message)
        }
    }
}