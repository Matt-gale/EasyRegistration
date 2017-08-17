//
//  TransitionViewController.swift
//  EasyRegistrationIOS
//
//  Created by Ye He on 19/7/17.
//
//

import UIKit

class TransitionViewController: UIViewController {
    private var currentViewController: UIViewController!
    
    private lazy var loginViewController: SignInViewController = {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "loginVC") as! SignInViewController
        
        return viewController
    }()
    
    private lazy var signUpViewController: SignUpViewController = {
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "signUpVC") as! SignUpViewController
        
        return viewController
    }()
    
    private lazy var mainViewController: MainViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "mainVC") as! MainViewController
        
        return viewController
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initCurrentVC(with: loginViewController)
    }
    
    private func initCurrentVC(with viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
        currentViewController = viewController
    }
    
    public func transitionToSignUpVC() {
        addChildViewController(signUpViewController)
        view.addSubview(signUpViewController.view)
        
        self.transition(from: currentViewController,
                        to: signUpViewController,
                        duration: 0.5,
                        options: .transitionCrossDissolve,
                        animations: nil,
                        completion: { _ in
                            self.currentViewController.removeFromParentViewController()
                            
                            self.signUpViewController.view.frame = self.view.bounds
                            self.signUpViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            self.signUpViewController.didMove(toParentViewController: self)
                            self.currentViewController = self.signUpViewController
        })
    }
    
    public func transitionToMainVC() {
        addChildViewController(mainViewController)
        view.addSubview(mainViewController.view)
        
        self.transition(from: currentViewController,
                        to: mainViewController,
                        duration: 0.5,
                        options: .transitionCurlUp,
                        animations: nil,
                        completion: { _ in
                            self.currentViewController.removeFromParentViewController()
                            
                            self.mainViewController.view.frame = self.view.bounds
                            self.mainViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            self.mainViewController.didMove(toParentViewController: self)
                            self.currentViewController = self.mainViewController
        })
    }
    
    public func transitionToLoginVC() {
        addChildViewController(loginViewController)
        view.addSubview(loginViewController.view)
        
        self.transition(from: currentViewController,
                        to: loginViewController,
                        duration: 0.5,
                        options: .transitionCrossDissolve,
                        animations: nil,
                        completion: { _ in
                            self.currentViewController.removeFromParentViewController()
                            
                            self.loginViewController.view.frame = self.view.bounds
                            self.loginViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                            self.loginViewController.didMove(toParentViewController: self)
                            self.currentViewController = self.loginViewController
        })
    }
    
}
