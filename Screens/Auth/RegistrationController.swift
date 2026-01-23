import UIKit

final class RegistrationController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel = UILabel()
    private let displayNameField = UITextField()
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let createButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardHandling()
    }
    
    private func setupUI() {
        view.backgroundColor = Theme.Colors.background
        title = "Create Account"
        
        // Navigation
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        // Scroll view for keyboard
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        contentView.frame = scrollView.bounds
        contentView.autoresizingMask = [.flexibleWidth]
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = "Welcome to Pulse"
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.frame = CGRect(x: 40, y: 60, width: view.bounds.width - 80, height: 40)
        contentView.addSubview(titleLabel)
        
        // Display Name Field
        setupTextField(displayNameField, placeholder: "Display Name (e.g., Alice)", y: 140)
        displayNameField.autocapitalizationType = .words
        
        // Username Field
        setupTextField(usernameField, placeholder: "Username (e.g., alice123)", y: 210)
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        
        // Password Field
        setupTextField(passwordField, placeholder: "Password", y: 280)
        passwordField.isSecureTextEntry = true
        
        // Create Button
        createButton.setTitle("Create Account", for: .normal)
        createButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        createButton.backgroundColor = Theme.Colors.accent
        createButton.setTitleColor(.white, for: .normal)
        createButton.layer.cornerRadius = 25
        createButton.frame = CGRect(x: 40, y: 360, width: view.bounds.width - 80, height: 50)
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        contentView.addSubview(createButton)
        
        // Activity Indicator
        activityIndicator.color = .white
        activityIndicator.center = createButton.center
        activityIndicator.isHidden = true
        contentView.addSubview(activityIndicator)
        
        contentView.frame.size.height = 500
        scrollView.contentSize = contentView.frame.size
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, y: CGFloat) {
        textField.placeholder = placeholder
        textField.font = .systemFont(ofSize: 17)
        textField.textColor = .white
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        textField.layer.cornerRadius = 12
        textField.borderStyle = .none
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftViewMode = .always
        textField.returnKeyType = .next
        textField.frame = CGRect(x: 40, y: y, width: view.bounds.width - 80, height: 50)
        
        // Placeholder color
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        
        contentView.addSubview(textField)
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapCreate() {
        view.endEditing(true)
        
        guard let displayName = displayNameField.text, !displayName.isEmpty,
              let username = usernameField.text, !username.isEmpty,
              let password = passwordField.text, password.count >= 6 else {
            showError("Please fill all fields. Password must be at least 6 characters.")
            return
        }
        
        // Validate username format (alphanumeric + underscore)
        let usernameRegex = "^[a-zA-Z0-9_]{3,20}$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        guard usernamePredicate.evaluate(with: username) else {
            showError("Username must be 3-20 characters (letters, numbers, underscore only)")
            return
        }
        
        // Show loading
        createButton.isEnabled = false
        createButton.setTitle("", for: .normal)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        // Listen for response
        TinodeClient.shared.onCtrl = { [weak self] ctrl in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.createButton.isEnabled = true
                self.createButton.setTitle("Create Account", for: .normal)
                
                if ctrl.code == 200 {
                    // Success
                    self.completeRegistration()
                } else {
                    // Error
                    let errorMsg = ctrl.text.isEmpty ? "Registration failed. Username may be taken." : ctrl.text
                    self.showError(errorMsg)
                }
            }
        }
        
        // Send create account request
        TinodeClient.shared.createAccount(
            username: username,
            password: password,
            displayName: displayName
        )
    }
    
    private func completeRegistration() {
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Save login state
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        // Save token
        if let token = TinodeClient.shared.sessionToken {
            UserDefaults.standard.set(token, forKey: "tinode_token")
        }
        
        // Dismiss and transition
        dismiss(animated: true) {
            if let window = UIApplication.shared.windows.first,
               let root = window.rootViewController as? RootController {
                root.transitionToMainApp()
            }
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
