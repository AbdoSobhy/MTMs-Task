//
//  UIViews+Extenstion.swift
//  MTMs-Task
//
//  Created by Abdelrahman Sobhy on 2/5/21.
//

import UIKit

@IBDesignable
class ImageCircled: UIView {
    
}

extension UIView{
    
    @IBInspectable var cornerRadius : CGFloat{
        set{
            self.layer.cornerRadius = newValue
        }
        get{
            return self.layer.cornerRadius
        }
    }
    @IBInspectable var borderWidth : CGFloat{
        set{
            self.layer.borderWidth = newValue
        }
        get{
            return self.layer.borderWidth
        }
    }
    @IBInspectable var borderColor : UIColor{
        set{
            self.layer.borderColor = newValue.cgColor        }
        get{
            return UIColor(cgColor: self.layer.borderColor! )
        }
    }
}
