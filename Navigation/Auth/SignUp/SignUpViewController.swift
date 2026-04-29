//
//  SignUpViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 04.04.2026.
//

import UIKit
import FirebaseAuth

final class SignUpViewController: UIViewController {
    
    weak var coordinator: LoginCoordinator?
    let viewModel: SignUpViewModel
    
    private var selectedAvatar: Avatar = .avatar1
    
    init(coordinator: LoginCoordinator?, viewModel: SignUpViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Регистрация аккаунта"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Укажите данные для входа"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private let emailStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = LayoutConstants.cornerRadius
        stack.distribution = .fillEqually
        stack.backgroundColor = .systemGray6
        stack.clipsToBounds = true
        return stack
    }()
    
    private let nameStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layer.borderColor = UIColor.lightGray.cgColor
        stack.layer.borderWidth = 0.5
        stack.layer.cornerRadius = LayoutConstants.cornerRadius
        stack.distribution = .fillEqually
        stack.backgroundColor = .systemGray6
        stack.clipsToBounds = true
        return stack
    }()
    
    private let secondInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расскажите о себе"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let profileStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()

    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .top
        return stack
    }()
    
    private let nameField: UITextField = {
        let name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.placeholder = "Имя"
        name.layer.borderWidth = 0.25
        name.layer.borderColor = UIColor.lightGray.cgColor
        name.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        name.leftViewMode = .always
        name.clipsToBounds = true
        name.backgroundColor = .systemGray6
        return name
    }()
    
    private let lastnameField: UITextField = {
        let name = UITextField()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.placeholder = "Фамилия"
        name.layer.borderWidth = 0.25
        name.layer.borderColor = UIColor.lightGray.cgColor
        name.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        name.leftViewMode = .always
        name.clipsToBounds = true
        name.backgroundColor = .systemGray6
        return name
    }()
    
    private let loginField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Почта"
        tf.layer.borderWidth = 0.25
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Пароль"
        tf.layer.borderWidth = 0.25
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemGray5
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.widthAnchor.constraint(equalToConstant: 100).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return iv
    }()
    
    private let birthDateField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Дата рождения"
        tf.layer.borderWidth = 0.25
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = LayoutConstants.cornerRadius
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        tf.leftViewMode = .always
        tf.backgroundColor = .systemGray6
        return tf
    }()

    private let datePicker = UIDatePicker()
    
    private let genderControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Мужской", "Женский"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private lazy var signUpButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemGreen
        btn.setTitle("Завершить регистрацию", for: .normal)
        btn.layer.cornerRadius = LayoutConstants.cornerRadius
        btn.addTarget(self, action: #selector(touchSignUpButton), for: .touchUpInside)
        return btn
    }()
    
    private let agreementLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нажимая кнопку \"Завершить регистрацию\", вы соглашаетесь с условиями использования и политикой конфиденциальности"
        label.font = .systemFont(ofSize: 8, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "FirstColor")
        
        setupUI()
        setupConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tap)
        
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels

        birthDateField.inputView = datePicker

        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailStackView)
        contentView.addSubview(signUpButton)
        contentView.addSubview(infoLabel)
        contentView.addSubview(secondInfoLabel)
        contentView.addSubview(horizontalStack)
        contentView.addSubview(agreementLabel)

        horizontalStack.addArrangedSubview(avatarImageView)
        horizontalStack.addArrangedSubview(profileStackView)

        profileStackView.addArrangedSubview(nameStackView)
        profileStackView.addArrangedSubview(birthDateField)
        profileStackView.addArrangedSubview(genderControl)
        
        nameStackView.addArrangedSubview(nameField)
        nameStackView.addArrangedSubview(lastnameField)
        
        emailStackView.addArrangedSubview(loginField)
        emailStackView.addArrangedSubview(passwordField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            infoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            emailStackView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 10),
            emailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emailStackView.heightAnchor.constraint(equalToConstant: 100),
            
            secondInfoLabel.topAnchor.constraint(equalTo: emailStackView.bottomAnchor, constant: 50),
            secondInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            secondInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            horizontalStack.topAnchor.constraint(equalTo: secondInfoLabel.bottomAnchor, constant: 10),
            horizontalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            horizontalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            profileStackView.heightAnchor.constraint(equalToConstant: 200),
            
            nameStackView.heightAnchor.constraint(equalToConstant: 100),
            
            birthDateField.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 50),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            agreementLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 10),
            agreementLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            agreementLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    @objc private func touchSignUpButton() {
        
        guard let email = loginField.text,
              let password = passwordField.text,
              let name = nameField.text,
              let lastName = lastnameField.text,
              let birthDate = datePicker.date as Date?,
              !email.isEmpty,
              !password.isEmpty,
              !name.isEmpty,
              !lastName.isEmpty else {
            
            showAlert(message: "Заполните все поля")
            return
        }
        
        let gender = genderControl.selectedSegmentIndex == 0 ? "male" : "female"
        
        viewModel.signUp(
            email: email,
            password: password,
            name: name,
            lastName: lastName,
            birthday: birthDate,
            gender: gender,
            avatar: selectedAvatar
        ) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserStorage.shared.save(user)
                    self?.coordinator?.didLoginSuccessfully(user: user)
                    
                case .failure(let error):
                    let message = self?.viewModel.handleAuthError(error)
                    self?.showAlert(message: message ?? "")
                }
            }
        }
    }
    
    @objc private func selectAvatar() {
        let vc = AvatarSelectionViewController { [weak self] avatar in
            self?.selectedAvatar = avatar
            self?.avatarImageView.image = avatar.image
        }
        
        present(vc, animated: true)
    }
    
    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        birthDateField.text = formatter.string(from: datePicker.date)
    }
    
    @objc private func keyboardShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        scrollView.contentInset.bottom = keyboardFrame.height
    }
    
    @objc private func keyboardHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}


