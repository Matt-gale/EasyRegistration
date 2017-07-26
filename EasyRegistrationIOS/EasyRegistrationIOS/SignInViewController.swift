//
//  SignInViewController.swift
//  EasyRegistrationIOS
//
//  Created by Ye He on 14/7/17.
//
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var emailBorder = CAShapeLayer()
    var passwordBorder = CAShapeLayer()
    
    let borderColor = UIColor(red: 31 / 255.0, green: 163 / 255.0, blue: 224 / 255.0, alpha: 1.0).cgColor
    let width = CGFloat(2.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldBorders()
    }
    
    private func setupTextFieldBorders() {
        setupBorder(for: emailTF, shapeLayer: emailBorder)
        setupBorder(for: passwordTF, shapeLayer: passwordBorder)
    }
    
    private func setupBorder(for textField: UITextField, shapeLayer: CAShapeLayer) {
        let borderPath = getBorderPath(of : textField)
        
        shapeLayer.path = borderPath.cgPath
        shapeLayer.strokeEnd = 0.0
        shapeLayer.strokeColor = borderColor
        shapeLayer.fillColor = borderColor
        shapeLayer.lineWidth = 2.0
        textField.layer.addSublayer(shapeLayer)
    }
    
    private func getBorderPath(of textField: UITextField) -> UIBezierPath {
        let borderPath = UIBezierPath()
        let yPos = textField.bounds.size.height - width
        
        let start = CGPoint(x: 0, y: yPos)
        let end = CGPoint(x: textField.bounds.size.width, y: yPos)
        borderPath.move(to: start)
        borderPath.addLine(to: end)
        
        return borderPath
    }
    
    @IBAction func emailValueChanged(_ sender: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.recheck(sender:)), object: sender)
        self.perform(#selector(self.recheck(sender:)), with: sender, afterDelay: 0.5)
    }
    
    
    @objc private func recheck(sender: UITextField) {

    }
    
    
    @IBAction func emailTFFocused(_ sender: UITextField) {
        setupFocusAnimation(for: emailBorder)
    }
    
    @IBAction func emailTFUnfocused(_ sender: UITextField) {
        setupUnFocusAnimation(for: emailBorder)
    }
    
    @IBAction func passwordTFFocused(_ sender: UITextField) {
        setupFocusAnimation(for: passwordBorder)
    }
    
    @IBAction func passwordTFUnfocused(_ sender: UITextField) {
        setupUnFocusAnimation(for: passwordBorder)
    }
    
    // start or remove 'focus' animation for the border of a text field depends on whether previous animations are finished
    private func setupFocusAnimation(for borderLayer: CAShapeLayer) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let withdrawAni = borderLayer.animation(forKey: "withdrawLineAnimation")
        let drawAni = borderLayer.animation(forKey: "drawLineAnimation")
        
        if drawAni == nil && withdrawAni == nil {
            borderLayer.strokeStart = 0.0
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.5
            borderLayer.strokeEnd = 1.0
            borderLayer.add(animation, forKey: "drawLineAnimation")
        } else {
            borderLayer.removeAllAnimations()
            borderLayer.strokeStart = 0.0
            borderLayer.strokeEnd = 1.0
        }
        
        CATransaction.commit()
    }
    
    // start or remove 'unfocus' animation of the border of a text field depends on whether previous animations are finished
    private func setupUnFocusAnimation(for borderLayer: CAShapeLayer) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let withdrawAni = borderLayer.animation(forKey: "withdrawLineAnimation")
        let drawAni = borderLayer.animation(forKey: "drawLineAnimation")
        
        if drawAni == nil && withdrawAni == nil {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.5
            borderLayer.strokeStart = 1.0
            borderLayer.add(animation, forKey: "withdrawLineAnimation")
        } else {
            borderLayer.removeAllAnimations()
            borderLayer.strokeStart = 1.0
        }
        
        CATransaction.commit()
    }
    
    @IBAction func switchToSignup(_ sender: UIButton) {
        let rootVC = UIApplication.shared.delegate!.window!!.rootViewController! as! TransitionViewController
        rootVC.transitionToSignUpVC()
    }
    
    @IBAction func login(_ sender: UIButton) {
        let rootVC = UIApplication.shared.delegate!.window!!.rootViewController! as! TransitionViewController
        rootVC.transitionToMainVC()
    }
}

