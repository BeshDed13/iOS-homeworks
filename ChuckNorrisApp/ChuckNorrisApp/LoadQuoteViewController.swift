//
//  LoadQuoteViewController.swift
//  ChuckNorrisApp
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class LoadQuoteViewController: UIViewController {
    
    let realmService = RealmService()
    
    let quoteLabel = UILabel()
    let loadButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Load Quote"
        
        quoteLabel.numberOfLines = 0
        quoteLabel.textAlignment = .center
        quoteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        loadButton.setTitle("Load quote", for: .normal)
        loadButton.setTitleColor(UIColor.white, for: .normal)
        loadButton.backgroundColor = .systemBlue
        loadButton.layer.cornerRadius = 8
        loadButton.translatesAutoresizingMaskIntoConstraints = false
        loadButton.addTarget(self, action: #selector(loadQuote), for: .touchUpInside)
        
        nextButton.setTitle("All loaded quotes", for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.layer.cornerRadius = 8
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(showAllLoadedQuotes), for: .touchUpInside)
        
        view.addSubview(quoteLabel)
        view.addSubview(loadButton)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            quoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
            loadButton.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 20),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.widthAnchor.constraint(equalToConstant: 200),
            loadButton.heightAnchor.constraint(equalToConstant: 50),
                    
            nextButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func loadQuote() {
        APIService.shared.fetchQuote { result in
            switch result {
            case .success(let quote):
                DispatchQueue.main.async {
                    self.quoteLabel.text = quote.value
                    self.realmService.save(quote)
                }
            case .failure(let error):
                print("Error fetching quote: \(error)")
            }
        }
    }
    
    @objc func showAllLoadedQuotes() {
        let vc = QuotesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
