//
//  TextInputExtension.swift
//  TextInputer
//
//  Created by 张贵广 on 2022/1/10.
//

import UIKit

public protocol TextInputExtension: UIView {
    
    var _text: String { get set }
    
    /// default is (top: 8, left: 4, bottom: 8, right: 4)
    var padding: UIEdgeInsets { get set }
    
    /// regular expression
    var regexString: String? { get set }
    
    /// default 0, no limit
    var lengthLimit: Int { get set }
    
    var borderNormalColor: UIColor? { get set }
    var borderFocusedColor: UIColor? { get set }
    
    /// default is nil.  label will be created if necessary.
    var placeholderLabel: UILabel? { get set }
}

extension TextInputExtension {
    
    func renderNormalBorder(check: Bool = true) {
        if check, isFirstResponder {
            return
        }
        
        layer.borderColor = borderNormalColor?.cgColor
        if layer.borderWidth == 0, borderNormalColor != nil {
            layer.borderWidth = 1
        }
    }
    
    func renderFocusedBorder(check: Bool = true) {
        if check, !isFirstResponder {
            return
        }
        if let c = borderFocusedColor {
            layer.borderColor = c.cgColor
            if layer.borderWidth == 0 {
                layer.borderWidth = 1
            }
        } else {
            renderNormalBorder(check: false)
        }
    }
    
    func checkChangeValid(in range: NSRange, replacementText text: String) -> Bool {
        repeat {
            if text.isEmpty {
                break // is delete
            }
            
            let old = _text
            let new = old.replacingCharacters(in: Range(range, in: old)!, with: text)
            
            if lengthLimit > 0, new.count > lengthLimit {
                _text = String(new.prefix(lengthLimit))
                return false // We only return false
            }
            
            if let pattern = regexString,
               let regex = try? NSRegularExpression(pattern: pattern),
               regex.numberOfMatches(in: new, options: [], range: NSRange(location: 0, length: new.count)) == 0 {
                return false // We only return false
            }
            
        } while false
        return true
    }
}
