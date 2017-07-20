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
    
    var emailBorder = CAShapeLayer()
    var passwordBorder = CAShapeLayer()
    
    var emailTick = CAShapeLayer()
    var passwordTick = CAShapeLayer()
    
    let borderColor = UIColor(red: 31 / 255.0, green: 163 / 255.0, blue: 224 / 255.0, alpha: 1.0).cgColor
    let width = CGFloat(2.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldBorders()
        
        setupTickLayers()
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
    
    
    private func setupTickLayers() {
        setupTickLayer(for: emailTF, shapeLayer: emailTick)
        setupTickLayer(for: passwordTF, shapeLayer: passwordTick)
    }
    
    private func setupTickLayer(for textField: UITextField, shapeLayer: CAShapeLayer) {
        let tickPath = getTickPath(of: textField)
        
        shapeLayer.path = tickPath.cgPath
        shapeLayer.strokeColor = borderColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeEnd = 0.0
        textField.layer.addSublayer(shapeLayer)
    }
    
    private func getTickPath(of textField: UITextField) -> UIBezierPath {
        let tickPath = UIBezierPath()
        let spaceToRight = CGFloat(5.0)
        let halfTickHeight = CGFloat(5.0)
        let xPos = textField.bounds.size.width - spaceToRight - halfTickHeight * 3
        let yPos = (textField.bounds.size.height - width) / 2
        
        let start = CGPoint(x: xPos, y: yPos)
        let end = CGPoint(x: xPos + halfTickHeight, y: yPos + halfTickHeight)
        let end2 = CGPoint(x: xPos + halfTickHeight * 3, y: yPos - halfTickHeight)
        
        tickPath.move(to: start)
        tickPath.addLine(to: end)
        tickPath.addLine(to: end2)
        
        return tickPath
    }
    
    
    @IBAction func switchToLoginVC(_ sender: UIButton) {
        let rootVC = UIApplication.shared.delegate!.window!!.rootViewController! as! TransitionViewController
        rootVC.transitionToLoginVC()
    }
    
    @IBAction func emailValueChanged(_ sender: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.recheckEmail(sender:)), object: sender)
        self.perform(#selector(self.recheckEmail(sender:)), with: sender, afterDelay: 0.5)
    }
    
    @IBAction func passwordValueChanged(_ sender: UITextField) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.recheckPassword(sender:)), object: sender)
        self.perform(#selector(self.recheckPassword(sender:)), with: sender, afterDelay: 0.5)
    }
    
    @objc private func recheckEmail(sender: UITextField) {
        emailTick.removeAllAnimations()
        
        guard let text = sender.text, !text.isEmpty else {
            //            implicit animation
            emailTick.strokeEnd = 0.0
            return
        }
        
        setupTickAnimation(for: emailTick)
    }
    
    @objc private func recheckPassword(sender: UITextField) {
        guard let text = sender.text, !text.isEmpty else {
            //            implicit animation
            passwordTick.strokeEnd = 0.0
            return
        }
        
        setupTickAnimation(for: passwordTick)
    }
    
    private func setupTickAnimation(for tickLayer: CAShapeLayer) {
        tickLayer.removeAllAnimations()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.3
        tickLayer.strokeEnd = 1.0
        tickLayer.add(animation, forKey: "drawTickAnimation")
        
        CATransaction.commit()
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
}
