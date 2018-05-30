//
//  ViewController.swift
//  ANAShowAvailableDevice
//
//  Created by Jack Wong on 2018/05/24.
//  Copyright © 2018 Jack. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    //MARK: Properties
    private let beamAPIDao = BeamAPIDao()
    
    //MARK: -IBOutlet
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginPage()
    }
    
    //MARK: -IBAction
    @IBAction func loginAction(_ sender: Any) {
        login()
    }
}

extension ViewController {
    private func login(){
        if !(emailAddress.text?.isEmpty)! && !(password.text?.isEmpty)! {
            beamAPIDao.checkUserExistOrNot(email: emailAddress.text!)
        }
    }
    private func setupLoginPage(){
        beamAPIDao.result = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: FetchResultDelegate
extension ViewController: FetchResult {
    
    func set(status: FetchAPIStatus) {
        switch status {
        case .success:
            let availableDevicesVC = AvailableDevicesViewController.make(with: emailAddress.text!)
            self.navigationController?.pushViewController(availableDevicesVC, animated: true)
            break
        case .error(let message):
            let alert = AlertHelper.buildAlert(title: "ERROR".localized(), message: message, rightButtonTitle: "ALERT_OK".localized(), leftButtonTitle: nil, rightButtonAction: nil, leftButtonAction: nil)
            present(alert, animated: true)
            print(message)
            break
        default:
            break
        }
    }
    
}
