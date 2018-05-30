//
//  ViewController.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/24.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: -IBOutlet
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: -IBAction
    @IBAction func loginAction(_ sender: Any) {
        login()
    }
}

extension ViewController {
    private func login(){
        if !(emailAddress.text?.isEmpty)! && !(password.text?.isEmpty)! {
           let availableDevicesVC = AvailableDevicesViewController.make(with: emailAddress.text!)
            self.navigationController?.pushViewController(availableDevicesVC, animated: true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
