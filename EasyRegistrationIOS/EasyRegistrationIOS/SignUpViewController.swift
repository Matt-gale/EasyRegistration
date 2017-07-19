//
//  SignUpViewController.swift
//  EasyRegistrationIOS
//
//  Created by Ye He on 19/7/17.
//
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func switchToLoginVC(_ sender: UIButton) {
        let rootVC = UIApplication.shared.delegate!.window!!.rootViewController! as! TransitionViewController
        rootVC.transitionToLoginVC()
    }

}
