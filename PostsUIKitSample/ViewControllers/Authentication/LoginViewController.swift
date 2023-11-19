//
//  LoginViewController.swift
//  PostsUIKitSample
//
//  Created by Berkay Dişli on 15.11.2023.
//

import UIKit

class LoginViewController: UIViewController {
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .systemGreen
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let appLabel: UILabel = {
       let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Hi there,", attributes: [.font: UIFont.systemFont(ofSize: 27, weight: .regular), .foregroundColor:UIColor.label])
        let welcomeString = NSAttributedString(string: "\nWelcome back!", attributes: [.font: UIFont.systemFont(ofSize: 27, weight: .semibold), .foregroundColor:UIColor.systemGreen])
        attributedText.append(welcomeString)
        label.attributedText = attributedText
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private let forgotPasswordButton: UIButton = {
       let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    private let button = CustomBigButton(bgColor: .systemGreen, color: .label, title: "Sign In", cornerStyle: .small)
    private let emailField = CustomTextField(textFieldType: .email)
    private let passwordField = CustomTextField(textFieldType: .password)
    private let goToRegistirationButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Don't have an account?", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular), .foregroundColor:UIColor.label])
        let welcomeString = NSAttributedString(string: " Sign Up.", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold), .foregroundColor:UIColor.systemGreen])
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
    
    private let viewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel) {
        self.viewModel = authViewModel
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = .secondarySystemBackground
        
        configureUI()
    }
    
    private func configureUI() {
        // Set up the closure to observe changes in isNetworking
        viewModel.isNetworkingDidChange = { [weak self] isNetworking in
            DispatchQueue.main.async {
                self?.updateLoadingIndicator(isNetworking)
            }
        }
        
        view.addSubview(appLabel)
        appLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 24, paddingLeft: 16)
        
        view.addSubview(stackView)
        stackView.anchor(top: appLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16)
        stackView.addArrangedSubview(emailField)
        emailField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        stackView.addArrangedSubview(passwordField)
        passwordField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)

        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.anchor(top: stackView.bottomAnchor, right: view.rightAnchor, paddingTop: 12, paddingRight: 16)
        
        view.addSubview(button)
        button.anchor(top: forgotPasswordButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16, height: 55)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        
        view.addSubview(goToRegistirationButton)
        goToRegistirationButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        goToRegistirationButton.centerX(inView: view)
        goToRegistirationButton.addTarget(self, action: #selector(goToRegisterButtonTapped), for: .touchUpInside)
        
        view.addSubview(loadingIndicator)
        loadingIndicator.center = view.center
    }
   
    @objc func goToRegisterButtonTapped() {
        let registerVC = RegisterViewController(viewModel: viewModel)
        navigationController?.pushViewController(registerVC, animated: true)
    }
    
    @objc func signInButtonTapped() {
        viewModel.loginUser { success in
            if success {
                print("DEBUG successfully logged in!")
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    @objc func textFieldTextChanged(sender: UITextField) {
        switch sender {
        case emailField:
            viewModel.email = emailField.text ?? ""
        case passwordField:
            viewModel.password = passwordField.text ?? ""
        default:
            break
        }
    }
    
    
    // Update the UI based on the isNetworking state
    private func updateLoadingIndicator(_ isNetworking: Bool) {
        if isNetworking {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
}
