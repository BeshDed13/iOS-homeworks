//
//  CustomButton.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 26.01.2026.
//

import Foundation
import UIKit

final class CustomButton: UIButton {
    
    private var action: (() -> Void)?
    
    init(
        title: String,
        titleColor: UIColor = .white,
        backgroundColor: UIColor = .systemBlue,
        cornerRadius: CGFloat = 8.0,
        action: (() -> Void)? = nil
    ) {
        self.action = action
        super.init(frame: .zero)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        setupView(
            title: title,
            titleColor: titleColor,
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(
        title: String,
        titleColor: UIColor,
        backgroundColor: UIColor,
        cornerRadius: CGFloat
    ) {
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc private func didTap() {
        action?()
    }
}
