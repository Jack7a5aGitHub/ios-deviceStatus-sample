//
//  AvailableDevicesProvider.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/24.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

final class AvailableDevicesProvider: NSObject {
    private var items = [DeviceInfo]()
    
    func set(items: [DeviceInfo]){
        self.items = items
    }
}

extension AvailableDevicesProvider: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AvailableDevicesTableViewCell.className, for: indexPath) as? AvailableDevicesTableViewCell else {
            fatalError()
        }
        let currentStatus = items[indexPath.row].state
        if currentStatus.callState == "STATE_AVAILABLE" {
            cell.setStatus(status: "使用可能")
        } else {
            cell.setStatus(status: "使用中")
        }
         cell.setText(type: items[indexPath.row].deviceTypeName, name: items[indexPath.row].name)
        return cell
    }
}
