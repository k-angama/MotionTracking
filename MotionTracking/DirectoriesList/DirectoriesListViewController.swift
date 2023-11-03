//
//  DirectoriesListViewController.swift
//  MotionTracking
//
//  Created by Karim Angama on 01/11/2023.
//

import UIKit

class DirectoriesListViewController: BaseViewController<DirectoriesListViewModel> {
    
    @IBOutlet weak var noDirectoriesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Override methode
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.didFileAdded()
    }
    
    override func setupUI() {
        super.setupUI()
    } 
    
    override func setupObservers() {
        super.setupObservers()
        
        // Reload data when files added
        viewModel.directoriesDidChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.reloadData()
            }
            .store(in: &cancellable)
        
        viewModel.reloadRows
            .receive(on: DispatchQueue.main)
            .sink { [weak self] index in
                self?.reloadRows(index: index)
            }
            .store(in: &cancellable)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? FilesListViewController {
            viewController.viewModel.removeFileEntity
                .sink { [weak self] entity in
                    self?.viewModel.removeFileEntity.send(entity)
                }
                .store(in: &cancellable)
        }
    }
    
    // MARK: Private methode

    private func reloadData() {
        tableView.reloadData()
    }
    
    private func reloadRows(index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    @IBAction func addDirectory(_ sender: Any) {
        
    }
    
}


// MARK: TableView Data Source

extension DirectoriesListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.directories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DirectoriesListTableViewCell
        cell.configuration(entity: viewModel.directories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedDirectory(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
