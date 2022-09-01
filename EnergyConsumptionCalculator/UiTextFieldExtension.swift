//
//  UiTextFieldExtension.swift
//  EnergyConsumptionCalculator
//
//  Created by M.Ali on 20/08/2022.
//

import Foundation
import UIKit
private var kAssociationKeyMaxLength: Int = 0

//extension UITextField {
//
//@IBInspectable var maxLength: Int {
//    get {
//        if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
//            return length
//        } else {
//            return Int.max
//        }
//    }
//    set {
//        objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
//        self.addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
//    }
//}
//
//func isInputMethod() -> Bool {
//    if let positionRange = self.markedTextRange {
//        if let _ = self.position(from: positionRange.start, offset: 0) {
//            return true
//        }
//    }
//    return false
//}
//
//
//@objc func checkMaxLength(textField: UITextField) {
//
//    guard !self.isInputMethod(), let prospectiveText = self.text,
//        prospectiveText.count > maxLength
//        else {
//            return
//    }
//
//    let selection = selectedTextRange
//    let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
//    text = prospectiveText.substring(to: maxCharIndex)
//    selectedTextRange = selection
//  }
//
//}



private var maxLengths = [UITextField: Int]()
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            guard let maxLen = maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return maxLen
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let txt = textField.text
        textField.text = txt?.safelyLimitedTo(length: maxLength)
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    func errorShowSuperView(message: String) {
        self.text! = ""
        self.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        self.superview?.shakeAnimation()
    }
    func errorShow(message: String) {
        self.text! = ""
        self.attributedPlaceholder = NSAttributedString(string: message, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        self.shakeAnimation()
    }
//    func errorShow(message: String) {
//        self.text! = ""
//        self.attributedPlaceholder = NSAttributedString(string: message.description, attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//        self.shakeAnimation()
//    }
    func setPlaceHolder(newPlaceholder: String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: newPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
}

extension String {
    func safelyLimitedTo(length len: Int) -> String {
        if self.count <= len {
            return self
        }
        return String( Array(self).prefix(upTo: len) )
    }
}
