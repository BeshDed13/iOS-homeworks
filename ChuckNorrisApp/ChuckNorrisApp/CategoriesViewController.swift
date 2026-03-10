//
//  CategoriesViewController.swift
//  ChuckNorrisApp
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit
import RealmSwift

final class CategoriesViewController: UITableViewController {
    
    let realmService = RealmService()
    var categories: Results<Category>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        categories = realmService.fetchCategories()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CategoryQuotesViewController()
        vc.category = categories[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

final class CategoryQuotesViewController: UITableViewController {
    
    var category: Category!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category.quotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = category.quotes[indexPath.row].text
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}
