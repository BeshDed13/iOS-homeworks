//
//  QuotesViewController.swift
//  ChuckNorrisApp
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit
import RealmSwift

final class QuotesViewController: UITableViewController {
    
    let realmService = RealmService()
    var quotes: Results<Quote>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quotes"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        quotes = realmService.fetchQuotes()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = quotes[indexPath.row].text
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CategoriesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
