//
//  LogInVC.swift
//  TradingStore
//
//  Created by ARMBP on 3/12/23.
//

import UIKit

protocol SendUserProtocol{
    func sendUser(usersFirstName: String)
}

class LogInVC: UIViewController {
    private lazy var titleLabel = UILabel()
    private lazy var userInfoStack = UIStackView()
    private lazy var firstNameTextField   = CustomTextField(frame: .zero)
    private lazy var passWordTextField   = CustomTextField(frame: .zero)
    
    private lazy var logInButton = UIButton()
    private lazy var signInButton = UIButton()
    private lazy var tooglePassWordVisibilityButton = UIButton()
    
    private var delegateMain: SendUserProtocol?
    private lazy var isPassWordIsHidden = Bool()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configure()
        self.view.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    
    private func configure(){
        isPassWordIsHidden = true
        configureTitleLabel()
        configureTextFields()
        configureUserInfoStackStackView()
        setPassWordVisibility()
        configureLogInButton()
        configureSignInButton()
    }
    
    
    //MARK: - Configure UI
    private func configureTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 30)
        titleLabel.textColor = .label
        titleLabel.text = "Log In"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/4),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    
    private func configureUserInfoStackStackView(){
        view.addSubview(userInfoStack)
        userInfoStack.translatesAutoresizingMaskIntoConstraints = false
        userInfoStack.backgroundColor = .systemBackground
        userInfoStack.addArrangedSubview(firstNameTextField)
        userInfoStack.addArrangedSubview(passWordTextField)
        userInfoStack.axis = .vertical
        userInfoStack.alignment = .center
        userInfoStack.distribution = .equalSpacing
        userInfoStack.spacing = 40
        userInfoStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        userInfoStack.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            userInfoStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            userInfoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            userInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    
    private func configureTextFields(){
        view.addSubviews(firstNameTextField, passWordTextField)
        let textFieldsArray = [firstNameTextField, passWordTextField]
        for i in textFieldsArray{
            i.font = UIFont(name: "Montserrat", size: 15)
            i.translatesAutoresizingMaskIntoConstraints = false
            i.autocapitalizationType = .none
            i.delegate = self
        }
        
        firstNameTextField.placeholder = "First name"
        passWordTextField.placeholder = "Password"
        passWordTextField.isSecureTextEntry = true
        passWordTextField.addSubview(tooglePassWordVisibilityButton)
        tooglePassWordVisibilityButton.translatesAutoresizingMaskIntoConstraints = false
        tooglePassWordVisibilityButton.tintColor = .label
        tooglePassWordVisibilityButton.backgroundColor = nil
        tooglePassWordVisibilityButton.addTarget(self, action: #selector(pwVisibilityAction), for: .touchUpInside)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        passWordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passWordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            passWordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            passWordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            tooglePassWordVisibilityButton.trailingAnchor.constraint(equalTo: passWordTextField.trailingAnchor, constant: -10),
            tooglePassWordVisibilityButton.centerYAnchor.constraint(equalTo: passWordTextField.centerYAnchor),
        ])
    }
    
    
    private func configureLogInButton(){
        view.addSubview(logInButton)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Login", for: .normal)
        logInButton.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
        logInButton.backgroundColor = .systemCyan
        logInButton.layer.borderWidth = 0
        logInButton.layer.cornerRadius = 10
        logInButton.isUserInteractionEnabled = false
        logInButton.backgroundColor = .systemGray
        logInButton.addTarget(self, action: #selector(logInAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.topAnchor.constraint(equalTo: userInfoStack.bottomAnchor, constant: 20),
            logInButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    
    private func configureSignInButton(){
        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Back to sign in", for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
        signInButton.layer.borderWidth = 0
        signInButton.layer.cornerRadius = 10
        signInButton.setTitleColor(.systemCyan, for: .normal)
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 20),
            signInButton.centerXAnchor.constraint(equalTo: logInButton.centerXAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    
    private func setPassWordVisibility(){
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        switch isPassWordIsHidden {
        case true:
            passWordTextField.isSecureTextEntry = true
            tooglePassWordVisibilityButton.setImage(UIImage(systemName: "eye.slash.circle", withConfiguration: largeConfig), for: .normal)
        default:
            passWordTextField.isSecureTextEntry = false
            tooglePassWordVisibilityButton.setImage(UIImage(systemName: "eye.circle", withConfiguration: largeConfig), for: .normal)
        }
    }
    
    
    private func areTextFieldsEmptyFunc(){
        switch firstNameTextField.text != "" && passWordTextField.text != "" {
        case true:
            logInButton.isUserInteractionEnabled = true
            logInButton.backgroundColor = .systemCyan
        default:
            logInButton.isUserInteractionEnabled = false
            logInButton.backgroundColor = .systemGray
        }
    }
    
    //MARK: - TextFieldDidChange action
    @objc func textFieldDidChange(_ textField: UITextField) {
        areTextFieldsEmptyFunc()
    }
    
    
    //MARK: - Buttons' actions
    @objc private func logInAction(){
        guard PersistenceManager.sharedRealm.userExist(primaryKey: firstNameTextField.text!) else {
            presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: "Incorrect first name or password", butonTitle: "Ok")
            return
        }
        
        let vc = CustomTabBar()
        self.delegateMain = (vc as any SendUserProtocol)
        delegateMain?.sendUser(usersFirstName: firstNameTextField.text!)
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc private func pwVisibilityAction(){
        isPassWordIsHidden.toggle()
        setPassWordVisibility()
    }
    
    
    @objc private func signInAction(){
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - DismissKeyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate
extension LogInVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            firstNameTextField.placeholder = ""
        case passWordTextField:
            passWordTextField.placeholder = ""
        default:
            break
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            firstNameTextField.placeholder = "First name"
            
        case passWordTextField:
            passWordTextField.placeholder = "Password"
            
        default:
            break
        }
    }
}

