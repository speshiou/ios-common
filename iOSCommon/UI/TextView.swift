//
//  TextView.swift
//  bbforum
//
//  Created by Pei-shiou Huang on 1/17/19.
//  Copyright © 2019 YUHO. All rights reserved.
//

import UIKit

open class TextView: UITextView {
    @IBInspectable var maxHeight: CGFloat = -1
    @IBInspectable var isOnlyLinkClickable: Bool = false
    @IBInspectable var linkColor: UIColor?
    
    public weak var textViewDelegate: UITextViewDelegate?
    
    var placeholderLabel: UILabel!
    var placeholderLabelTop: NSLayoutConstraint!
    var placeholderLabelLeft: NSLayoutConstraint!
    public var placeholder: String? {
        didSet {
            placeholderLabel?.text = placeholder
            
            if placeholder?.isEmpty == false, placeholderLabel == nil {
                placeholderLabel = UILabel(frame: CGRect.zero)
                if #available(iOS 13.0, *) {
                    placeholderLabel.textColor = .secondaryLabel
                } else {
                    placeholderLabel.textColor = .lightGray
                }
                addSubview(placeholderLabel)
                placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
                placeholderLabelTop = placeholderLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: self.textContainerInset.top)
                placeholderLabelTop.isActive = true
                placeholderLabelLeft = placeholderLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: self.textContainerInset.left)
                placeholderLabelLeft.isActive = true
            }
            placeholderLabel.text = placeholder
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.textContainerInset = UIEdgeInsets.zero
        self.textContainer.lineFragmentPadding = 0
        self.delegate = self
        self.translatesAutoresizingMaskIntoConstraints = false
        if self.maxHeight > -1 {
            self.heightAnchor.constraint(lessThanOrEqualToConstant: self.maxHeight).isActive = true
        }
        if let linkColor = self.linkColor {
            self.linkTextAttributes = [ .foregroundColor: linkColor ]
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabelTop?.constant = self.textContainerInset.top
        placeholderLabelLeft?.constant = self.textContainerInset.left
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let pos = closestPosition(to: point) else { return false }
        if self.isOnlyLinkClickable {
            guard let range = tokenizer.rangeEnclosingPosition(pos, with: .character, inDirection: .layout(.left)) else { return false }
            let startIndex = offset(from: beginningOfDocument, to: range.start)
            return attributedText.attribute(.link, at: startIndex, effectiveRange: nil) != nil
        }
        return true
    }
}

extension TextView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if self.maxHeight > -1 {
            if self.contentSize.height >= self.maxHeight {
                self.isScrollEnabled = true
            }
            else {
                self.frame.size.height = textView.contentSize.height
                self.isScrollEnabled = false
            }
        }
        self.placeholderLabel?.isHidden = textView.text.count > 0
        self.textViewDelegate?.textViewDidChange?(textView)
    }
    
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return self.textViewDelegate?.textView?(textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
}
