//
//  ChatViewController.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 16.04.2026.
//

import UIKit

final class ChatViewController: UIViewController {
    
    private let viewModel: ChatViewModel
    private let chatId: String
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.keyboardDismissMode = .interactive
        return tv
    }()
    
    private let inputContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.font = .systemFont(ofSize: 16)
        tv.layer.cornerRadius = 10
        tv.backgroundColor = .secondarySystemBackground
        tv.isScrollEnabled = false
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        return tv
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Сообщение"
        label.textColor = .placeholderText
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "paperplane.fill")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Чат"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    init(viewModel: ChatViewModel, chatId: String) {
        self.viewModel = viewModel
        self.chatId = chatId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "FirstColor")
        navigationItem.titleView = titleLabel
        
        setupViews()
        setupConstraints()
        setupTable()
        bind()
        
        viewModel.start(chatId: chatId)
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(inputContainer)
        
        inputContainer.addSubview(textView)
        inputContainer.addSubview(sendButton)
        textView.addSubview(placeholderLabel)
        
        textView.delegate = self
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        sendButton.setContentHuggingPriority(.required, for: .horizontal)
        sendButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            inputContainer.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            inputContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            textView.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 8),
            textView.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 8),
            textView.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -8),
            textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 10),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 8),
            
            sendButton.leadingAnchor.constraint(equalTo: textView.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -8),
            sendButton.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.heightAnchor.constraint(equalToConstant: 36),
            
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
    
    private func setupTable() {
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "messageCell")
    }
    
    private func bind() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
                let count = self.viewModel.messages.count
                if count > 0 {
                    let index = IndexPath(row: count - 1, section: 0)
                    self.tableView.scrollToRow(at: index, at: .bottom, animated: true)
                }
            }
        }
    }
    
    @objc private func sendTapped() {
        viewModel.send(text: textView.text ?? "")
        textView.text = ""
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let message = viewModel.messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "messageCell",
            for: indexPath
        ) as! MessageCell
        
        cell.configure(with: message)
        
        return cell
    }
}

extension ChatViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        textView.isScrollEnabled = estimatedSize.height > 120
    }
}
