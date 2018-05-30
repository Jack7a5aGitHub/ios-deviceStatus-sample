//
//  AvailableDevicesTableViewCell.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/24.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

class AvailableDevicesTableViewCell: UITableViewCell {

    @IBOutlet weak var beamType: UILabel!
    @IBOutlet weak var beamName: UILabel!
    @IBOutlet weak var state: UILabel!
    
    static var identifier: String {
        return self.className
    }
    
    static var nibName: String {
        return self.className
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - Setter
    func setText(type: String, name: String) {
        beamType.text = "タイプ:\(type)"
        beamName.text = "名前:\(name)"
    }
    
    func setStatus(status: String) {
        state.text = "状態:\(status)"
    }
}
