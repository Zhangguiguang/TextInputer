//
//  GGTextView.swift
//  TextInputer
//
//  Created by 张贵广 on 2022/1/15.
//

import Foundation
import UIKit

public class GGTextView: UIView, TextInputExtension {
    
    // MARK: - TextView Properties
    public let textView: UITextView
    
    public weak var delegate: UITextViewDelegate?
    public var text: String! {
        get { textView.text }
        set {
            textView.text = newValue
            updatePlaceholder()
        }
    }
    public var font: UIFont? {
        get { textView.font }
        set { textView.font = newValue }
    }
    public var textColor: UIColor? {
        get { textView.textColor }
        set { textView.textColor = newValue }
    }
    public var textAlignment: NSTextAlignment {
        get { textView.textAlignment }
        set { textView.textAlignment = newValue }
    }
    
    public init(frame: CGRect = .zero, textContainer: NSTextContainer? = nil) {
        textView = UITextView(frame: frame, textContainer: textContainer)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 14)
        super.init(frame: frame)
        textView.delegate = self
        addSubview(textView)
    }
    required init?(coder: NSCoder) {
        textView = UITextView(frame: .zero)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 14)
        super.init(coder: coder)
        textView.delegate = self
        addSubview(textView)
    }

    // MARK: - TextInputExtension Properties
    public var _text: String {
        get { textView.text }
        set { textView.text = newValue }
    }
    
    public var padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4) {
        didSet {
            setNeedsLayout()
            textView.textContainerInset = UIEdgeInsets(top: 0, left: padding.left, bottom: 0, right: padding.right)
            textView.textContainer.lineFragmentPadding = 0
        }
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
                _placeholderLabel?.numberOfLines = 0
                addSubview(_placeholderLabel!)
            }
            return _placeholderLabel
        }
        set {
            _placeholderLabel?.removeFromSuperview()
            _placeholderLabel = newValue
            if _placeholderLabel != nil {
                _placeholderLabel?.numberOfLines = 0
                addSubview(_placeholderLabel!)
            }
        }
    }
}

// MARK: - Responder
extension GGTextView {
    public override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
    }
    public override var canBecomeFirstResponder: Bool {
        textView.canBecomeFirstResponder
    }
    public override func resignFirstResponder() -> Bool {
        textView.resignFirstResponder()
    }
    public override var canResignFirstResponder: Bool {
        textView.canResignFirstResponder
    }
    public override var isFirstResponder: Bool {
        textView.isFirstResponder
    }
}

// MARK: - TextInputExtension Support
extension GGTextView {
    public override func layoutSubviews() {
        super.layoutSubviews()
        textView.frame = bounds.inset(by: UIEdgeInsets(top: padding.top, left: 0, bottom: padding.bottom, right: 0))
        var frame = bounds.inset(by: padding)
        frame.size.height = 0
        placeholderLabel?.frame = frame
        placeholderLabel?.sizeToFit()
    }
    
    @objc func updatePlaceholder() {
        _placeholderLabel?.isHidden = !_text.isEmpty
    }
}

extension GGTextView: UITextViewDelegate {
    // complement delegate function
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if delegate?.responds(to: aSelector) == true {
            return delegate
        } else {
            return super.forwardingTarget(for: aSelector)
        }
    }

    // complement delegate function
    public override func responds(to aSelector: Selector!) -> Bool {
        if delegate?.responds(to: aSelector) == true {
            return true
        } else {
            return super.responds(to: aSelector)
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        renderFocusedBorder(check: false)
        delegate?.textViewDidBeginEditing?(textView)
    }

    public func textViewDidEndEditing(_ textView: UITextView) {
        renderNormalBorder(check: false)
        delegate?.textViewDidEndEditing?(textView)
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        updatePlaceholder()
        delegate?.textViewDidChange?(textView)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !checkChangeValid(in: range, replacementText: text) {
            return false
        }
        
        // The string is valid, now let the real delegate decide
        return delegate?.textView?(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
}
