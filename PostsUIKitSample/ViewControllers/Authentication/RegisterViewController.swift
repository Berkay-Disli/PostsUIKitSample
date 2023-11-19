//
//  RegisterViewController.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 15.11.2023.
//

import UIKit
import Photos

class RegisterViewController: UIViewController {
    private var profileImage: UIImage?
    private lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        button.tintColor = .white
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handlePhoto), for: .touchUpInside)
        return button
    }()
    
    let viewModel: AuthViewModel
    private let appLabel: UILabel = {
       let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Hello,", attributes: [.font: UIFont.systemFont(ofSize: 27, weight: .regular), .foregroundColor:UIColor.label])
        let welcomeString = NSAttributedString(string: "\nWelcome to PostApp!", attributes: [.font: UIFont.systemFont(ofSize: 27, weight: .semibold), .foregroundColor:UIColor.systemGreen])
        attributedText.append(welcomeString)
        label.attributedText = attributedText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private let registerButton = CustomBigButton(bgColor: .systemGreen, color: .label, title: "Sign Up", cornerStyle: .small)
    private let usernameField = CustomTextField(textFieldType: .username)
    private let emailField = CustomTextField(textFieldType: .email)
    private let passwordfield = CustomTextField(textFieldType: .password)
    private let popToLoginButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Already have an account?", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular), .foregroundColor:UIColor.label])
        let welcomeString = NSAttributedString(string: " Sign In.", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold), .foregroundColor:UIColor.systemGreen])
        attributedText.append(welcomeString)
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }()
    
    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
//        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationController?.setNavigationBarHidden(true, animated: true)
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(appLabel)
        appLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)
        
        view.addSubview(cameraButton)
        cameraButton.anchor(top: appLabel.bottomAnchor, paddingTop: 24 , width: 100, height: 100)
        cameraButton.centerX(inView: view)
        
        view.addSubview(stackView)
        stackView.anchor(top: cameraButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        stackView.addArrangedSubview(usernameField)
        usernameField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        stackView.addArrangedSubview(emailField)
        emailField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        stackView.addArrangedSubview(passwordfield)
        passwordfield.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        
        view.addSubview(registerButton)
        registerButton.anchor(top: stackView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16, height: 55)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        view.addSubview(popToLoginButton)
        popToLoginButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        popToLoginButton.centerX(inView: view)
        popToLoginButton.addTarget(self, action: #selector(popToLoginTapped), for: .touchUpInside)
    }
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    */
   
    @objc func popToLoginTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func goToMainTabBarView() {
        let mainVC = MainTabBarViewController(authViewModel: viewModel)
        mainVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(mainVC, animated: true)
    }
    
    @objc func registerButtonTapped() {
        viewModel.registerUser(image: profileImage) { success in
            if success {
                print("DEBUG SUCCESSFULLY CREATED USER INSIDE REGISTERVIEW")
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    @objc func textFieldTextChanged(sender: UITextField) {
        switch sender {
        case usernameField:
            viewModel.username = usernameField.text ?? ""
        case emailField:
            viewModel.email = emailField.text ?? ""
        case passwordfield:
            viewModel.password = passwordfield.text ?? ""
        default:
            break
        }
    }
    
    @objc private func handlePhoto(_ sender: UIButton){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .notDetermined:
                    break
                case .restricted:
                    break
                case .denied:
                    break
                case .authorized:
                    DispatchQueue.main.async {
                        let picker = UIImagePickerController()
                        picker.delegate = self
                        self.present(picker, animated: true)
                    }
                case .limited:
                    break
                @unknown default:
                    break
                }
                
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        self.profileImage = image
        cameraButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        cameraButton.clipsToBounds = true
        cameraButton.layer.cornerRadius = 100 / 2
        cameraButton.contentMode = .scaleAspectFill
        cameraButton.layer.borderColor = UIColor.white.cgColor
        cameraButton.layer.borderWidth = 2
        self.dismiss(animated: true)
    }
}
