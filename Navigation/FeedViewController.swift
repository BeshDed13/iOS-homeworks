//
//  FeedViewController.swift
//  Navigation
//

import UIKit

final class FeedViewController: UIViewController {
    
    private let model = FeedModel()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter word"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var checkGuessButton = CustomButton(
        title: "Check",
        backgroundColor: .systemGreen
    ) { [weak self] in
        self?.checkWord()
    }
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemTeal
        createSubView()
        bindModel()
    }
    
    private func createSubView() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            stackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -32)
        ])
        
        addPostButton(
            title: "Post number One",
            color: .systemPurple,
            to: stackView
        ) { [weak self] in
            self?.openPost(at: 0)
        }
        
        addPostButton(
            title: "Post number Two",
            color: .systemIndigo,
            to: stackView
        ) { [weak self] in
            self?.openPost(at: 1)
        }
        
        stackView.addArrangedSubview(textField)
        stackView.addArrangedSubview(checkGuessButton)
        stackView.addArrangedSubview(resultLabel)
    }
    
    private func addPostButton(
        title: String,
        color: UIColor,
        to stackView: UIStackView,
        action: @escaping () -> Void
    ) {
        let button = CustomButton(
            title: title,
            backgroundColor: color,
            action: action
        )
        
        stackView.addArrangedSubview(button)
    }
    
    private func openPost(at index: Int) {
        let post = postExamples[index]
        
        let postVC = PostViewController()
        postVC.post = post
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    private func bindModel() {
        model.onCheckResult = { [weak self] isCorrect in
            self?.resultLabel.text = isCorrect ? "Correct!" : "Try again."
            self?.resultLabel.textColor = isCorrect ? .green : .red
            
        }
    }
    
    private func checkWord() {
        guard let text = textField.text, !text.isEmpty else {
            resultLabel.text = "Please, enter a word."
            resultLabel.textColor = .white
            return
        }
        
        model.check(word: text)
    }
}
