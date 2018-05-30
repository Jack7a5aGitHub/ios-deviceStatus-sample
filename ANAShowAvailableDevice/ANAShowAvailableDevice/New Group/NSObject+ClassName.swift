//
//  NSObject+ClassName.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/24.
//  Copyright © 2018 Jack. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// クラス名を取得する
    static var className: String {
        return String(describing: self)
    }
}
