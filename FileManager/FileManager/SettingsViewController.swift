//
//  SettingsViewController.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 24.02.2026.
//

import Foundation
import UIKit

final class SettingsViewController: UITableViewController {
    
    private let viewModel: SettingsViewModel
    
    var onChangePassword: (() -> Void)?
    
    init(viewModel: SettingsViewModel, onChangePassword: (() -> Void)? = nil) {
        self.viewModel = viewModel
        self.onChangePassword = onChangePassword
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Section: Int, CaseIterable {
        case sorting
        case security
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)!
        
        switch section {
        case .sorting:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Sorting A-Z"
            let toggle = UISwitch()
            toggle.isOn = viewModel.isAscending
            toggle.addTarget(self, action: #selector(sorting(_:)), for: .valueChanged)
            cell.accessoryView = toggle
            return cell
        case .security:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Change Password"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)!
        
        tableView.deselectRow(at: indexPath, animated: true)
        if section == .security {
            onChangePassword?()
        }
    }
    
    @objc private func sorting(_ sender: UISwitch) {
        viewModel.toggleSorting(isOn: sender.isOn)
    }
}
