//
//  InfoViewController.swift
//  Navigation
//

import UIKit

final class InfoViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let planetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.backgroundColor = .systemGray6
        
        createAlertButton()
        
        fetchJSON()
        fetchPlanet()
    }
    
    private func fetchJSON() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let dictionary = jsonObject as? [String: Any] {
                    
                    let object = JSON(
                        userId: dictionary["userId"] as? Int ?? 0,
                        id: dictionary["id"] as? Int ?? 0,
                        title: dictionary["title"] as? String ?? "",
                        completed: dictionary["completed"] as? Bool ?? false
                    )
                    
                    DispatchQueue.main.async {
                        self.titleLabel.text = object.title
                    }
                }
            } catch {
                print("JSON error:", error)
            }
        }
        task.resume()
    }
    
    private func fetchPlanet() {
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            do {
                let planet = try JSONDecoder().decode(Planet.self, from: data)
                
                DispatchQueue.main.async {
                    self.planetLabel.text = "Orbital period: \(planet.orbitalPeriod)"
                }
            } catch {
                print("Decoding error:", error)
            }
        }
        task.resume()
    }
    
    private func createAlertButton() {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Alert", for: .normal)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = LayoutConstants.cornerRadius
        button.addTarget(self, action: #selector(tapAlertButton), for: .touchUpInside)
                
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func tapAlertButton() {
        let alert = UIAlertController(title: "Attention",
                                      message: "How are you feeling?",
                                      preferredStyle: .alert)
        // add two buttons
        let fine = UIAlertAction(title: "Fine", style: .default) { _ in
            print("Fine")
        }
        alert.addAction(fine)
        
        let so = UIAlertAction(title: "So-so", style: .destructive) { _ in
            print("So-so")
        }
        alert.addAction(so)

        self.present(alert, animated: true, completion: nil)
    }
}
