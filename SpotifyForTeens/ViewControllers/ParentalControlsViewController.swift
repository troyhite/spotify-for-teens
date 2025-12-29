//
//  ParentalControlsViewController.swift
//  SpotifyForTeens
//
//  Created on 2025-12-29
//

import UIKit

class ParentalControlsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let manager = ParentalControlsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        title = "Parental Controls"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showPinSetup() {
        let alert = UIAlertController(title: "Set Parental PIN", message: "Enter a 4-digit PIN to protect parental controls", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter PIN"
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Set PIN", style: .default) { [weak self] _ in
            guard let pin = alert.textFields?.first?.text, pin.count == 4 else {
                self?.showError("Please enter a 4-digit PIN")
                return
            }
            self?.manager.setPin(pin)
            self?.tableView.reloadData()
        })
        
        present(alert, animated: true)
    }
    
    private func verifyPinAndExecute(_ action: @escaping () -> Void) {
        guard manager.isPinSet else {
            showPinSetup()
            return
        }
        
        let alert = UIAlertController(title: "Enter PIN", message: "Enter your parental control PIN", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "PIN"
            textField.keyboardType = .numberPad
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Verify", style: .default) { [weak self] _ in
            guard let pin = alert.textFields?.first?.text else { return }
            if self?.manager.verifyPin(pin) == true {
                action()
            } else {
                self?.showError("Incorrect PIN")
            }
        })
        
        present(alert, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showFilterOptions() {
        let alert = UIAlertController(title: "Content Filter", message: "Choose a content filtering level", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Strict (Everyone)", style: .default) { [weak self] _ in
            self?.manager.currentFilter = .strict
            self?.tableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "Default (Teen 13+)", style: .default) { [weak self] _ in
            self?.manager.currentFilter = .default
            self?.tableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "Custom", style: .default) { [weak self] _ in
            self?.showCustomFilterSetup()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showCustomFilterSetup() {
        // Navigate to custom filter configuration screen
        let customVC = CustomFilterViewController()
        navigationController?.pushViewController(customVC, animated: true)
    }
}

extension ParentalControlsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // PIN status
        case 1: return 2 // Filter settings
        case 2: return 1 // Blocked keywords
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "Parental PIN"
            cell.detailTextLabel?.text = manager.isPinSet ? "Set" : "Not Set"
            cell.accessoryType = .disclosureIndicator
        case 1:
            if indexPath.row == 0 {
                cell.textLabel?.text = "Content Filter"
                cell.detailTextLabel?.text = manager.currentFilter.blockExplicitContent ? "Active" : "Off"
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.textLabel?.text = "Block Explicit Content"
                let toggle = UISwitch()
                toggle.isOn = manager.currentFilter.blockExplicitContent
                toggle.addTarget(self, action: #selector(explicitContentToggled(_:)), for: .valueChanged)
                cell.accessoryView = toggle
            }
        case 2:
            cell.textLabel?.text = "Blocked Keywords"
            cell.detailTextLabel?.text = "\(manager.currentFilter.blockedKeywords.count)"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Security"
        case 1: return "Content Filtering"
        case 2: return "Custom Filters"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            verifyPinAndExecute { [weak self] in
                self?.showPinSetup()
            }
        case 1:
            if indexPath.row == 0 {
                verifyPinAndExecute { [weak self] in
                    self?.showFilterOptions()
                }
            }
        case 2:
            verifyPinAndExecute { [weak self] in
                // Navigate to blocked keywords management
            }
        default:
            break
        }
    }
    
    @objc private func explicitContentToggled(_ sender: UISwitch) {
        verifyPinAndExecute { [weak self] in
            var filter = self?.manager.currentFilter ?? .default
            filter.blockExplicitContent = sender.isOn
            self?.manager.currentFilter = filter
        }
    }
}

class CustomFilterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Custom Filter"
        view.backgroundColor = .systemBackground
        
        // Implement custom filter configuration UI
    }
}
