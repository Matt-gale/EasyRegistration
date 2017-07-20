//
//  SignUpViewController.swift
//  EasyRegistrationIOS
//
//  Created by Ye He on 19/7/17.
//
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    var EmailBorder: CAShapeLayer!
    var TickLayer: CAShapeLayer!
    
    let borderColor = UIColor(red: 31 / 255.0, green: 163 / 255.0, blue: 224 / 255.0, alpha: 1.0).cgColor
    let width = CGFloat(2.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEmailLayer();
        
        setupTickLayer()
    }
    
    private func setupEmailLayer() {
        let path = UIBezierPath()
        let yPos = emailTF.bounds.size.height - width
        
        let start = CGPoint(x: 0, y: yPos)
        let end = CGPoint(x: emailTF.bounds.size.width, y: yPos)
        path.move(to: start)
        path.addLine(to: end)
        
        //design path in layer
        EmailBorder = CAShapeLayer()
        EmailBorder.path = path.cgPath
        EmailBorder.strokeEnd = 0.0
        EmailBorder.strokeColor = borderColor
        EmailBorder.fillColor = borderColor
        EmailBorder.lineWidth = 2.0
        emailTF.layer.addSublayer(EmailBorder)
    }
    
    private func setupTickLayer() {
        let tickPath = UIBezierPath()
        let spaceToRight = CGFloat(5.0)
        let halfTickHeight = CGFloat(5.0)
        let xPos = emailTF.bounds.size.width - spaceToRight - halfTickHeight * 3
        let yPos = (emailTF.bounds.size.height - width) / 2
        
        let start = CGPoint(x: xPos, y: yPos)
        let end = CGPoint(x: xPos + halfTickHeight, y: yPos + halfTickHeight)
        let end2 = CGPoint(x: xPos + halfTickHeight * 3, y: yPos - halfTickHeight)
        
        tickPath.move(to: start)
        tickPath.addLine(to: end)
        tickPath.addLine(to: end2)
        
        TickLayer = CAShapeLayer()
        TickLayer.path = tickPath.cgPath
        
        TickLayer.strokeColor = borderColor
        TickLayer.fillColor = UIColor.clear.cgColor
        TickLayer.lineWidth = 2.0
        TickLayer.strokeEnd = 0.0
        emailTF.layer.addSublayer(TickLayer)
    }
    
    
    @IBAction func switchToLoginVC(_ sender: UIButton) {
        let rootVC = UIApplication.shared.delegate!.window!!.rootViewController! as! TransitionViewController
        rootVC.transitionToLoginVC()
    }
    
    @IBAction func emailValueChanged(_ sender: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.recheck(sender:)), object: sender)
        self.perform(#selector(self.recheck(sender:)), with: sender, afterDelay: 0.5)
    }
    
    @objc private func recheck(sender: UITextField) {
        TickLayer.removeAllAnimations()
        
        guard let text = sender.text, !text.isEmpty else {
            //            implicit animation
            TickLayer.strokeEnd = 0.0
            return
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.3
        TickLayer.strokeEnd = 1.0
        TickLayer.add(animation, forKey: "drawTickAnimation")
        
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
    }
    
    
    @IBAction func passwordTFUnfocused(_ sender: UITextField) {
    }
}
