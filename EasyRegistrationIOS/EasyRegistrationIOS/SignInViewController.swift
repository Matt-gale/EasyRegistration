//
//  SignInViewController.swift
//  EasyRegistrationIOS
//
//  Created by Ye He on 14/7/17.
//
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var EmailBorder: CAShapeLayer!
    var PWDBorder: CAShapeLayer!
    let borderColor = UIColor(red: 31 / 255.0, green: 163 / 255.0, blue: 224 / 255.0, alpha: 1.0).cgColor
    let width = CGFloat(2.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPasswordLayer()
        
        setupEmailLayer()
    }
    
    private func setupEmailLayer() {
        let path = UIBezierPath()
        let yPos = emailTF.bounds.size.height - width
        
        let start = CGPoint(x: 0, y: yPos)
        let end = CGPoint(x: emailTF.bounds.size.width, y: yPos)
        path.move(to: start)
        path.addLine(to: end)
        
        EmailBorder = CAShapeLayer()
        EmailBorder.path = path.cgPath
        EmailBorder.strokeEnd = 0.0
        EmailBorder.strokeColor = borderColor
        EmailBorder.fillColor = borderColor
        EmailBorder.lineWidth = 2.0
        emailTF.layer.addSublayer(EmailBorder)
    }
    
    private func setupPasswordLayer() {
        let path = UIBezierPath()
        let yPos = emailTF.bounds.size.height - width
        
        let start = CGPoint(x: 0, y: yPos)
        let end = CGPoint(x: passwordTF.bounds.size.width, y: yPos)
        path.move(to: start)
        path.addLine(to: end)
        
        
        PWDBorder = CAShapeLayer()
        PWDBorder.path = path.cgPath
        PWDBorder.strokeEnd = 0.0
        PWDBorder.strokeColor = borderColor
        PWDBorder.fillColor = borderColor
        PWDBorder.lineWidth = 2.0
        passwordTF.layer.addSublayer(PWDBorder)
        passwordTF.layer.masksToBounds = true
    }
    
    @IBAction func emailValueChanged(_ sender: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.recheck(sender:)), object: sender)
        self.perform(#selector(self.recheck(sender:)), with: sender, afterDelay: 0.5)
    }
    
    
    // todo: connect with tick and avoid duplicate layer creation
    @objc private func recheck(sender: UITextField) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let circleCenter = CGPoint(x: emailTF.bounds.width, y: emailTF.bounds.height / 3)
        let circleRadius = emailTF.bounds.height / 3 * 2 - width
        let start = Double.pi / 2
        let end = start + Double.pi / 2
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: CGFloat(circleRadius), startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: false)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeEnd = 0.0
        circleLayer.strokeColor = borderColor
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineWidth = 2.0
        
        emailTF.layer.addSublayer(circleLayer)
        
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.3
        circleLayer.add(animation, forKey: "drawCircleAnimation")
        
        CATransaction.commit()
    }
    
    
    @IBAction func emailTFFocused(_ sender: UITextField) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let withdrawAni = EmailBorder.animation(forKey: "withdrawLineAnimation")
        let drawAni = EmailBorder.animation(forKey: "drawLineAnimation")
        
        if drawAni == nil && withdrawAni == nil {
            EmailBorder.strokeStart = 0.0
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.5
            EmailBorder.strokeEnd = 1.0
            EmailBorder.add(animation, forKey: "drawLineAnimation")
        } else {
            EmailBorder.removeAllAnimations()
            EmailBorder.strokeStart = 0.0
            EmailBorder.strokeEnd = 1.0
        }
        
        CATransaction.commit()
    }
    
    @IBAction func emailTFUnfocused(_ sender: UITextField) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let withdrawAni = EmailBorder.animation(forKey: "withdrawLineAnimation")
        let drawAni = EmailBorder.animation(forKey: "drawLineAnimation")
        
        if drawAni == nil && withdrawAni == nil {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.5
            EmailBorder.strokeStart = 1.0
            EmailBorder.add(animation, forKey: "withdrawLineAnimation")
        } else {
            EmailBorder.removeAllAnimations()
            EmailBorder.strokeStart = 1.0
        }
        
        CATransaction.commit()
    }
    
    @IBAction func passwordTFFocused(_ sender: UITextField) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let withdrawAni = PWDBorder.animation(forKey: "withdrawLineAnimation")
        let drawAni = PWDBorder.animation(forKey: "drawLineAnimation")
        
        if drawAni == nil && withdrawAni == nil {
            PWDBorder.strokeStart = 0.0
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.5
            PWDBorder.strokeEnd = 1.0
            PWDBorder.add(animation, forKey: "drawLineAnimation")
        } else {
            PWDBorder.removeAllAnimations()
            PWDBorder.strokeStart = 0.0
            PWDBorder.strokeEnd = 1.0
        }
        
        CATransaction.commit()
    }
    
    @IBAction func passwordTFUnfocused(_ sender: UITextField) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let withdrawAni = PWDBorder.animation(forKey: "withdrawLineAnimation")
        let drawAni = PWDBorder.animation(forKey: "drawLineAnimation")
        
        if drawAni == nil && withdrawAni == nil {
            let animation = CABasicAnimation(keyPath: "strokeStart")
            
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.5
            PWDBorder.strokeStart = 1.0
            PWDBorder.add(animation, forKey: "withdrawLineAnimation")
        } else {
            PWDBorder.removeAllAnimations()
            PWDBorder.strokeStart = 1.0
        }
        
        CATransaction.commit()
    }
    
    @IBAction func switchToSignup(_ sender: UIButton) {
        let rootVC = UIApplication.shared.delegate!.window!!.rootViewController! as! TransitionViewController
        rootVC.transitionToSignUpVC()
    }
    
}

