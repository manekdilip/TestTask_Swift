

import UIKit

// MARK:- UIView Inspectable
@IBDesignable extension UIView {
    
    @IBInspectable
    var cornerRadiusView: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var isCircle: Bool {
        get {
            return self.isCircle
        }
        set {
            DispatchQueue.main.async {
                self.cornerRadiusView = self.frame.size.width / 2
            }
            
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    func borderWidth(borderWidth : CGFloat) {
        
        self.layer.borderWidth = borderWidth
    }
    
    @IBInspectable
    var isShadow: Bool {
        get {
            return self.isShadow
        }
        set {
            layer.shadowColor = UIColor(red: 0.237, green: 0.501, blue: 0.818, alpha: 0.09).cgColor
            layer.shadowOpacity = 1
            layer.shadowOffset = CGSize(width: 0, height: 12)
            layer.shadowRadius = 19
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }
}
