//
//  CustomTextField.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 15.11.2023.
//

import UIKit

class CustomTextField: UITextField {

    enum CustomTextFieldType {
        case username, email, password
    }
    
    private let textFieldType: CustomTextFieldType
    private lazy var rightButton  = UIButton(type: .custom)
    
    init(textFieldType: CustomTextFieldType) {
        self.textFieldType = textFieldType
        super.init(frame: .zero)
        delegate = self
        
        self.backgroundColor      = .secondarySystemBackground
        self.layer.cornerRadius   = 4
        layer.borderWidth         = 2
        layer.borderColor         = UIColor.systemGray4.cgColor
        textColor                 = .label
        tintColor                 = .label
        textAlignment             = .left
        
        adjustsFontSizeToFitWidth = true
        minimumFontSize           = 12
        
        self.leftViewMode         = .always
        self.leftView             = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.anchor(height: 55)
        
        switch textFieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email"
            self.keyboardType = .emailAddress
            // Klavye türünü belirler. .emailAddress, kullanıcının bir e-posta adresi girmesi gerektiğini belirten bir klavye türüdür. Bu, klavyede @ sembolü ve diğer e-posta adresi karakterlerini kolayca erişilebilir hale getirir.
            
            self.textContentType = .emailAddress
            // Metin içeriği türünü belirler. .emailAddress, metin girişi sırasında otomatik tamamlama ve önerileri etkinleştirir ve kullanıcının e-posta adresi girmesini kolaylaştırır. Örneğin, daha önce kullanılan e-posta adreslerini önerme yeteneği gibi özellikleri içerebilir.
            
        case .password:
            self.placeholder = "Password"
            self.textContentType = .password
            self.isSecureTextEntry = true
            
            rightButton.setImage(UIImage(systemName: "eye.slash.fill") , for: .normal)
            rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
            rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
            rightButton.frame = CGRect(x: 0, y:0, width:30, height:30)
            
            rightViewMode = .always
            rightView = rightButton
        }
        
    }
    
    @objc
    func toggleShowHide(button: UIButton) {
        isSecureTextEntry = !isSecureTextEntry
        if isSecureTextEntry {
            rightButton.setImage(UIImage(systemName: "eye.slash.fill") , for: .normal)
        } else {
            rightButton.setImage(UIImage(systemName: "eye.fill") , for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
