//
//  ViewController.swift
//  FileManager
//
//  Created by Дмитрий Ильинский on 22.02.2026.
//

import UIKit

final class DocumentsViewController: UITableViewController {
    
    private let fileService = FileService()
    private var files: [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FileManager"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        loadFiles()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
    }
    
    private func loadFiles() {
        files = fileService.fetchFiles()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        files.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let fileURL = files[indexPath.row]
        cell.textLabel?.text = fileURL.lastPathComponent
        
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            cell.imageView?.image = image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let fileURL = files[indexPath.row]
            
            fileService.deleteFile(at: fileURL)
            files.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc private func addPhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
        
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            fileService.saveImage(image)
            loadFiles()
        }
        
        picker.dismiss(animated: true)
    }
}
