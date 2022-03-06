//
//  ViewController.swift
//  MotionTracking
//
//  Created by Karim Angama on 19/01/2022.
//

import UIKit

class FilesListViewController: BaseViewController<FilesListViewModel> {
    
    @IBOutlet weak var noFilesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: Override methode
    
    override func setupObservers() {
        super.setupObservers()

        // Hide the message if there is a list of files
        viewModel.$hiddenTextNoFile
            .receive(on: DispatchQueue.main)
            .assign(to: \.isHidden, on: noFilesLabel)
            .store(in: &cancellable)
        
        // Reload data when files added
        viewModel.filesDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellable)
        
        // Insert row in tableview
        viewModel.inserFile
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self]   _ in
                self?.inserRows()
            })
            .store(in: &cancellable)
        
        // Remove row from tableview
        viewModel.removeFile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.deleteRows(index)
            }
            .store(in: &cancellable)
        
    }
    
    /**
     Pass data to Export File ViewModel
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
           let viewController = navigationController.topViewController as? ExportFileViewController {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            viewController.viewModel.fileTrackingEntity = viewModel.files[indexPath.row]
        }
    }
    
    // MARK: Private methode
    
    private func inserRows() {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    private func deleteRows(_ index: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    private func reloadData() {
        tableView.reloadData()
    }

}

// MARK: TableView Data Source

extension FilesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FilesListTableViewCell
        cell.configuration(entity: viewModel.files[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.removeFile(index: indexPath.row)
    }
    
}


