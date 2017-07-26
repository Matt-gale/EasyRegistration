//
//  MenuViewController.swift
//  EasyRegistrationIOS
//
//  Created by Ye He on 24/7/17.
//
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func logout(_ sender: UIButton) {
        let rootVC = UIApplication.shared.delegate!.window!!.rootViewController! as! TransitionViewController
        rootVC.transitionToLoginVC()
    }
}
