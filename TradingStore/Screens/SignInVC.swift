//
//  SignInVC.swift
//  TradingStore
//
//  Created by ARMBP on 3/12/23.
//

import UIKit

class SignInVC: UIViewController {
    
    private let titleLabel = UILabel()
    private let ahaQuestionLabel = UILabel()
    private let invalidEmailLabel = UILabel()
    private let userInfoStack = UIStackView()
    private let appleGoogleButtonsStack = UIStackView()
    
    private let firstNameTextField   = CustomTextField(frame: .zero)
    private let lastNameTextField   = CustomTextField(frame: .zero)
    private let emailTextField   = CustomTextField(frame: .zero)
    
    private let signInButton = UIButton()
    private let logInButton = UIButton()
    private let googleButton = UIButton()
    private let appleButton = UIButton()
    private var delegateMain: SendUserProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        configureTitleLabel()
        configureTextFields()
        configureUserInfoStackStackView()
        configureSignInButton()
        configureAhaQuestionLabel()
        configureLogInButton()
        configureGoogleButton()
        configureAppleButton()
        configureAppleGoogleStackView()
        configureInvalidEmailLabel()
    }
    
    
    //MARK: - Configure UI
    private func configureTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Montserrat", size: 30)
        titleLabel.textColor = .label
        titleLabel.text = "Sign In"
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/4),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        
    }
    
    
    private func configureAhaQuestionLabel(){
        view.addSubview(ahaQuestionLabel)
        ahaQuestionLabel.translatesAutoresizingMaskIntoConstraints = false
        ahaQuestionLabel.font = UIFont(name: "Montserrat", size: 12)
        ahaQuestionLabel.text = "Already have an account?"
        
        NSLayoutConstraint.activate([
            ahaQuestionLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            ahaQuestionLabel.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor, constant: 2),
        ])
    }
    
    
    private func configureInvalidEmailLabel(){
        emailTextField.addSubview(invalidEmailLabel)
        invalidEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        invalidEmailLabel.text = "Email is invalid, chagne it, please"
        invalidEmailLabel.textColor = .systemRed
        invalidEmailLabel.isHidden = true
        invalidEmailLabel.font = UIFont(name: "Montserrat", size: 12)
        
        
        NSLayoutConstraint.activate([
            invalidEmailLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 3),
            invalidEmailLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor, constant: 2),
        ])
    }
    
    
    private func configureUserInfoStackStackView(){
        view.addSubview(userInfoStack)
        userInfoStack.translatesAutoresizingMaskIntoConstraints = false
        userInfoStack.backgroundColor = .systemBackground
        
        userInfoStack.addArrangedSubview(firstNameTextField)
        userInfoStack.addArrangedSubview(lastNameTextField)
        userInfoStack.addArrangedSubview(emailTextField)
        
        userInfoStack.axis = .vertical
        userInfoStack.alignment = .center // .leading .firstBaseline .center .trailing .lastBaseline
        userInfoStack.distribution = .equalSpacing // .fillEqually .fillProportionally .equalSpacing .equalCentering
        userInfoStack.spacing = 40
        userInfoStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        userInfoStack.isLayoutMarginsRelativeArrangement = true
        
        
        NSLayoutConstraint.activate([
            userInfoStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            userInfoStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //userInfoStack.heightAnchor.constraint(equalToConstant: 80),
            userInfoStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            userInfoStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    
    private func configureAppleGoogleStackView(){
        view.addSubview(appleGoogleButtonsStack)
        appleGoogleButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        appleGoogleButtonsStack.backgroundColor = .systemBackground
        appleGoogleButtonsStack.addArrangedSubview(googleButton)
        appleGoogleButtonsStack.addArrangedSubview(appleButton)
        appleGoogleButtonsStack.axis = .vertical
        appleGoogleButtonsStack.alignment = .center // .leading .firstBaseline .center .trailing .lastBaseline
        appleGoogleButtonsStack.distribution = .equalSpacing // .fillEqually .fillProportionally .equalSpacing .equalCentering
        appleGoogleButtonsStack.spacing = 20
        appleGoogleButtonsStack.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        appleGoogleButtonsStack.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            appleGoogleButtonsStack.topAnchor.constraint(equalTo: ahaQuestionLabel.bottomAnchor, constant: 40),
            appleGoogleButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleGoogleButtonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            appleGoogleButtonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
    }
    
    
    //MARK: - Configure TitleTextView
    private func configureTextFields(){
        view.addSubviews(firstNameTextField, lastNameTextField, emailTextField)
        let textFieldsArray = [firstNameTextField, lastNameTextField, emailTextField]
        
        for i in textFieldsArray{
            i.font = UIFont(name: "Montserrat", size: 15)
            i.translatesAutoresizingMaskIntoConstraints = false
            i.delegate = self
        }
        
        firstNameTextField.text = ""
        lastNameTextField.text = ""
        emailTextField.text = ""
        firstNameTextField.placeholder = "First name"
        lastNameTextField.placeholder = "Last name"
        emailTextField.placeholder = "Email"
        emailTextField.autocapitalizationType = .none
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        NSLayoutConstraint.activate([
            firstNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            firstNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            lastNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            lastNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    
    private func configureSignInButton(){
        view.addSubview(signInButton)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.setTitle("Sign in", for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
        signInButton.backgroundColor = .systemGray
        signInButton.isUserInteractionEnabled = false
        signInButton.layer.borderWidth = 0
        signInButton.layer.cornerRadius = 10
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: userInfoStack.bottomAnchor, constant: 30),
            signInButton.widthAnchor.constraint(equalToConstant: 300)
            
        ])
    }
    
    
    private func configureLogInButton(){
        view.addSubview(logInButton)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Log in", for: .normal)
        logInButton.titleLabel?.font = UIFont(name: "Montserrat", size: 12)
        logInButton.layer.borderWidth = 0
        logInButton.layer.cornerRadius = 10
        logInButton.setTitleColor(.systemCyan, for: .normal)
        logInButton.addTarget(self, action: #selector(logInAction), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            logInButton.topAnchor.constraint(equalTo: ahaQuestionLabel.topAnchor),
            logInButton.leadingAnchor.constraint(equalTo: ahaQuestionLabel.trailingAnchor, constant: 15),
            logInButton.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    
    private func configureGoogleButton(){
        view.addSubview(googleButton)
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        googleButton.addAction(UIAction{_ in  }, for: .touchUpInside)
        let googleLogo = UIImageView(image: UIImage(named: "GoogleLogo")?.withRenderingMode(.alwaysTemplate))
        let googleLoginLabel = UILabel()
        googleButton.addSubviews(googleLogo, googleLoginLabel)
        googleLogo.translatesAutoresizingMaskIntoConstraints = false
        googleLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        googleLoginLabel.text  = "Sign in with Google"
        googleLoginLabel.font = UIFont(name: "Montserrat", size: 15)
        googleLogo.tintColor = .label
        
        NSLayoutConstraint.activate([
            googleButton.widthAnchor.constraint(equalToConstant: 200),
            googleButton.heightAnchor.constraint(equalToConstant: 30),
            
            googleLogo.leadingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: 5),
            googleLogo.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor),
            googleLogo.heightAnchor.constraint(equalToConstant: 25),
            googleLogo.widthAnchor.constraint(equalToConstant: 25),
            
            googleLoginLabel.leadingAnchor.constraint(equalTo: googleLogo.trailingAnchor, constant: 10),
            googleLoginLabel.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor)
        ])
    }
    
    
    private func configureAppleButton(){
        view.addSubview(appleButton)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addAction(UIAction{_ in }, for: .touchUpInside)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        let appleLogoResized = UIImage(systemName: "apple.logo", withConfiguration: largeConfig)
        let appleLogo = UIImageView(image: appleLogoResized)
        let appleLoginLabel = UILabel()
        appleButton.addSubviews(appleLogo, appleLoginLabel)
        appleLogo.translatesAutoresizingMaskIntoConstraints = false
        appleLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        appleLoginLabel.text  = "Sign in with Apple"
        appleLoginLabel.font = UIFont(name: "Montserrat", size: 15)
        appleLogo.tintColor = .label
        
        NSLayoutConstraint.activate([
            appleButton.widthAnchor.constraint(equalToConstant: 200),
            appleButton.heightAnchor.constraint(equalToConstant: 30),
            
            appleLogo.leadingAnchor.constraint(equalTo: appleButton.leadingAnchor, constant: 5),
            appleLogo.centerYAnchor.constraint(equalTo: appleButton.centerYAnchor),
            appleLogo.heightAnchor.constraint(equalToConstant: 25),
            appleLogo.widthAnchor.constraint(equalToConstant: 25),
            
            appleLoginLabel.leadingAnchor.constraint(equalTo: appleLogo.trailingAnchor, constant: 10),
            appleLoginLabel.centerYAnchor.constraint(equalTo: appleButton.centerYAnchor),
        ])
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        guard let emailRegex = try? Regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        else { return false }
        return email.firstMatch(of: emailRegex) != nil
    }
    
    
    private func emailValidationFunc(){
        switch isValidEmail(emailTextField.text!) {
        case false:
            invalidEmailLabel.isHidden = false
            signInButton.isUserInteractionEnabled = false
            signInButton.backgroundColor = .systemGray
        default:
            invalidEmailLabel.isHidden = true
            signInButton.isUserInteractionEnabled = true
            signInButton.backgroundColor = .systemCyan
        }
    }
    
    
    private func areTextFieldsEmptyFunc(){
        switch emailTextField.text != "" && firstNameTextField.text != "" && lastNameTextField.text != "" {
        case true:
            emailValidationFunc()
        default:
            invalidEmailLabel.isHidden = true
            signInButton.isUserInteractionEnabled = false
            signInButton.backgroundColor = .systemGray
            emailTextField.placeholder = "Email"
        }
    }
    
    //MARK: - TextFieldDidChange action
    @objc func textFieldDidChange(_ textField: UITextField) {
        areTextFieldsEmptyFunc()
    }
    
    //MARK: - Buttons' actions
    @objc private func signInAction(){
        guard !PersistenceManager.sharedRealm.userExist(primaryKey: firstNameTextField.text!) else {// any parameters u want
            presentCustomAllertOnMainThred(allertTitle: "Bad Stuff Happend", message: "User already exists \n (change your first name)", butonTitle: "Ok")
            return
        }
        
        PersistenceManager.sharedRealm.addUser(firstName: firstNameTextField.text!, lastName: lastNameTextField.text! , email: emailTextField.text!)
        
        let vc = CustomTabBar()
        self.delegateMain = (vc as any SendUserProtocol)
        delegateMain?.sendUser(usersFirstName: firstNameTextField.text!)
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @objc private func logInAction(){
        self.dismiss(animated: true, completion: nil)
        let vc = LogInVC()
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Move keyboard down when input is active
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/4
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: - DismissKeyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


//MARK: - UITextFieldDelegate
extension SignInVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            firstNameTextField.placeholder = ""
            
        case lastNameTextField:
            lastNameTextField.placeholder = ""
            
        case emailTextField:
            emailTextField.placeholder = ""
        default:
            break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            firstNameTextField.placeholder = "First name"
    
        case lastNameTextField:
            lastNameTextField.placeholder = "Last name"
            
        case emailTextField:
            emailTextField.placeholder = "Email"
        default:
            break
        }
    }
    
}

