//
//  String+Localized.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/30.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
