//
//  CustomBigButton.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 15.11.2023.
//

import UIKit

class CustomBigButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(bgColor: UIColor ,color: UIColor, title: String, systemImageName: String? = nil, cornerStyle: UIButton.Configuration.CornerStyle? = .medium){
        self.init(frame: .zero)
        set(bgColor: bgColor ,color: color, title: title, systemImageName: systemImageName, cornerStyle: cornerStyle)
    }
    
    // MARK: - Configuration
    private func configure() {
        configuration = .tinted()
        configuration?.cornerStyle = .medium
        
    }
    
    func set(bgColor: UIColor ,color: UIColor, title: String, systemImageName: String?,cornerStyle: UIButton.Configuration.CornerStyle?) {
        configuration?.baseBackgroundColor = bgColor
        configuration?.baseForegroundColor = color
        configuration?.cornerStyle = cornerStyle ?? .medium
        configuration?.title = title
        
        if let imageName = systemImageName {
            configuration?.image = UIImage(systemName: imageName)
            configuration?.imagePadding = 6
        }
        
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    }
}
