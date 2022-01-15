//
//  GGTextField.swift
//  TextInputer
//
//  Created by 张贵广 on 2022/1/15.
//

import UIKit

public class GGTextField: UITextField, TextInputExtension {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        super.delegate = self
        self.addTarget(self, action: #selector(updatePlaceholder), for: .editingChanged)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.delegate = self
        self.addTarget(self, action: #selector(updatePlaceholder), for: .editingChanged)
    }
    
    private var realDelegate: UITextFieldDelegate?
    public override var delegate: UITextFieldDelegate? {
        get { realDelegate }
        set { realDelegate = newValue }
    }

    // MARK: - TextInputExtension Properties
    public var _text: String {
        get { text ?? "" }
        set { text = newValue }
    }
    
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4) {
        didSet { setNeedsLayout() }
    }
    
    public var regexString: String?
    
    public var lengthLimit: Int = 0
    
    public var borderNormalColor: UIColor? {
        didSet { renderNormalBorder() }
    }
    
    public var borderFocusedColor: UIColor? {
        didSet { renderFocusedBorder() }
    }
    
    var _placeholderLabel: UILabel?
    public var placeholderLabel: UILabel? {
        get {
            if _placeholderLabel == nil {
                _placeholderLabel = UILabel()
                _placeholderLabel?.font = font
                _placeholderLabel?.textColor = UIColor(white: 0.7, alpha: 1)
                addSubview(_placeholderLabel!)
            }
            return _placeholderLabel
        }
        set {
            _placeholderLabel?.removeFromSuperview()
            _placeholderLabel = newValue
            if _placeholderLabel != nil {
                addSubview(_placeholderLabel!)
            }
        }
    }
}

// MARK: - TextInputExtension Support
extension GGTextField {
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        super.textRect(forBounds: bounds).inset(by: padding)
    }
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        super.editingRect(forBounds: bounds).inset(by: padding)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        _placeholderLabel?.frame = bounds.inset(by: padding)
    }
    
    @objc func updatePlaceholder() {
        _placeholderLabel?.isHidden = !_text.isEmpty
    }
    
    public override var text: String? {
        didSet {
            updatePlaceholder()
        }
    }
}

extension GGTextField: UITextFieldDelegate {
    // complement delegate function
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if realDelegate?.responds(to: aSelector) == true {
            return realDelegate
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }

    // complement delegate function
    public override func responds(to aSelector: Selector!) -> Bool {
        if realDelegate?.responds(to: aSelector) == true {
            return true
        } else {
            return super.responds(to: aSelector)
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        renderFocusedBorder()
        realDelegate?.textFieldDidBeginEditing?(textField)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        renderNormalBorder(check: false)
        realDelegate?.textFieldDidEndEditing?(textField)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        renderNormalBorder(check: false)
        if realDelegate?.responds(to: #selector(textFieldDidEndEditing(_:reason:))) == true {
            realDelegate?.textFieldDidEndEditing?(textField, reason: reason)
        } else {
            realDelegate?.textFieldDidEndEditing?(textField)
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !checkChangeValid(in: range, replacementText: string) {
            return false
        }
        
        // The string is valid, now let the real delegate decide
        return realDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }
}
