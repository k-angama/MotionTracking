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
    
    override func setupUI() {
        super.setupUI()
        
        tableView.allowsMultipleSelectionDuringEditing = true
        navigationItem.rightBarButtonItem = editButtonItem

        let exportButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(exportTapped))
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [trashButton, spacer, exportButton]
    }

    override func setupObservers() {
        super.setupObservers()

        // Hide the message if there is a list of files
        viewModel.$isFilesExist
            .receive(on: DispatchQueue.main)
            .assign(to: \.isHidden, on: noFilesLabel)
            .store(in: &cancellable)
        
        // Disable Edit button if there are no files
        viewModel.$isFilesExist
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: editButtonItem)
            .store(in: &cancellable)
        
        viewModel.$isEditingViewController
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] value in
                self?.isEditing = value
            })
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
            .sink(receiveValue: { [weak self] _ in
                self?.inserRows()
            })
            .store(in: &cancellable)
        
        // Remove row from tableview
        viewModel.removeFiles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.deleteRows(index)
            }
            .store(in: &cancellable)
        
        // Show the toolbar
        viewModel.$showToolBar
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.navigationController?.setToolbarHidden(!value, animated: true)
            }
            .store(in: &cancellable)
        
        // Enable the edit button
        viewModel.$isEnabledButton
            .removeDuplicates()
            .sink { [weak self] value in
                self?.toolbarItems?.first?.isEnabled = value
                self?.toolbarItems?.last?.isEnabled = value
            }
            .store(in: &cancellable)
        
        // Show table view editing
        viewModel.$isEditingTableView
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if self?.tableView.isEditing != value {
                    self?.tableView.setEditing(value, animated: true)
                }
            }
            .store(in: &cancellable)
        
        // Show select all button
        viewModel.$isEditingTableView
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if !value {
                    self?.navigationItem.leftBarButtonItem = nil
                } else {
                    self?.navigationItem.leftBarButtonItem = UIBarButtonItem(
                        title: "Select all",
                        style: .plain,
                        target: self,
                        action: #selector(self?.selectAllTapped)
                    )
                }
            }
            .store(in: &cancellable)
        
        // Select all row
        viewModel.$isAllSelected
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.selectAllRow(value)
            }
            .store(in: &cancellable)
        
        viewModel.$stateSelectedButton
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                if value {
                    self?.navigationItem.leftBarButtonItem?.title = "Deselect all"
                }else{
                    self?.navigationItem.leftBarButtonItem?.title = "Select all"
                }
            }
            .store(in: &cancellable)
        
    }
    
    /**
     Pass data to Export File ViewModel
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
           let viewController = navigationController.topViewController as? ExportFileViewController {
            viewModel.$filesSelected.assign(to: &viewController.viewModel.$fileTrackingEntity)
        }

    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        viewModel.isEditingTableView = !viewModel.isEditingTableView
    }
    
    
    // MARK: Private methode
    
    private func inserRows() {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    private func deleteRows(_ index: [Int]) {
        tableView.deleteRows(at: index.flatMap {
            [IndexPath(row: $0, section: 0)]
        }, with: .automatic)
    }
    
    private func reloadData() {
        tableView.reloadData()
    }
    
    @objc func trashTapped() {
        confirmDeleteMessage()
    }
    
    @objc func exportTapped() {
        performSegue(withIdentifier: "ExportFileSegue", sender: nil)
    }
    
    @objc func selectAllTapped(sender: UIBarButtonItem) {
        viewModel.isAllSelected = !viewModel.isAllSelected
    }
    
    private func selectAllRow(_ value: Bool) {
        for section in 0..<tableView.numberOfSections {
            for row in 0..<tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: row, section: section)
                if !value {
                    tableView.deselectRow(at: indexPath, animated: false)
                } else {
                    tableView.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
                }
            }
        }
        filesSelected()
    }
    
    private func filesSelected() {
        viewModel.filesSelected = tableView.indexPathsForSelectedRows?
            .compactMap { viewModel.files[$0.row] } ?? []
    }
    
    private func confirmDeleteMessage() {
        let alertController = UIAlertController(
            title: "Delete files",
            message: "Are you sure you want to delete these files?",
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        alertController.addAction(
            UIAlertAction(title: "Yes", style: .destructive, handler: { [weak self] _ in
                self?.viewModel.removeMultiFiles()
            })
        )
        present(alertController, animated: true)
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
        filesSelected()
        if !tableView.isEditing  {
            performSegue(withIdentifier: "ExportFileSegue", sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        filesSelected()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeFile(index: indexPath.row)
        }
    }

}


