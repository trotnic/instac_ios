//
//  UVProjectListViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      13.04.21
//

import UIKit

class UVProjectListViewController: UIViewController {
    
    private struct Constants {
        static let cellIdentifier = "cell"
    }
    
    // MARK: - Props
    
    private var listViewModel: UVProjectListViewModelType
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    // MARK: - Initialization
    
    init(list lViewModel: UVProjectListViewModelType) {
        listViewModel = lViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        layoutTableView()
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createProject(_:)))
        ]
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension UVProjectListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listViewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = listViewModel.content(at: indexPath.row)
        return cell
    }
}

extension UVProjectListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // MARK: ♻️ REFACTOR LATER ♻️
        listViewModel.didSelect(itemAt: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.listViewModel.delete(at: indexPath.row)
            completion(true)
            self.tableView.deleteRows(at: [indexPath], with: .middle)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension UVProjectListViewController {
    @objc func createProject(_ sender: UIBarButtonItem) {
        // MARK: ♻️ REFACTOR LATER ♻️
        
        let creationDialog = UIAlertController(title: "New project",
                                               message: "Select a name for your project",
                                               preferredStyle: .alert)
        
        creationDialog.addTextField { (textField) in
            textField.placeholder = "Project name"
        }
        
        creationDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        creationDialog.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action) in
            if let projectName = creationDialog.textFields?.first?.text {
                // MARK: ♻️ REFACTOR LATER ♻️
                self.listViewModel.create(project: projectName)
            }
            self.tableView.reloadSections(.init([0]), with: .fade)
        }))
        
        present(creationDialog, animated: true, completion: nil)
    }
}
