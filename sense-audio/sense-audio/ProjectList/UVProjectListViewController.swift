//
//  UVProjectListViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      13.04.21
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class UVProjectListViewController: UIViewController {

    private struct Constants {

    }

    // MARK: - Props

    private var listViewModel: UVProjectListViewModelType
    private var dataSource: UVProjectListDatasourceType

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Initialization

    init(list lViewModel: UVProjectListViewModelType, data source: UVProjectListDatasourceType) {
        listViewModel = lViewModel
        dataSource = source
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()

        dataSource.setup(tableView: tableView)

        listViewModel
            .contents
            .on(value: { (contents) in
                self.dataSource.contents = contents
                self.tableView.reloadData()
            })
            .start()

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

extension UVProjectListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // MARK: ♻️ REFACTOR LATER ♻️
        listViewModel.didSelect(itemAt: indexPath.row)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [listViewModel, dataSource, tableView] (_, _, completion) in

            self.listViewModel
                .delete(at: indexPath.row)
                .combineLatest(with: listViewModel.contents.promoteError())
                .on(value: { _, contents in
                    dataSource.contents = contents
                    tableView.reloadSections(IndexSet([0]), with: .automatic)
                    completion(true)
                })
                .start()
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

        creationDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

        }))

        creationDialog.addAction(UIAlertAction(title: "Create", style: .default,
                                               handler: { [listViewModel, dataSource, tableView] (_) in
            if let projectName = creationDialog.textFields?.first?.text {
                self.listViewModel.create(project: projectName)
                    .producer
                    .combineLatest(with: listViewModel.contents.promoteError())
                    .on(value: { _, contents in
                        dataSource.contents = contents
                        tableView.reloadSections(IndexSet([0]), with: .fade)
                    })
                    .start()

            }
        }))

        present(creationDialog, animated: true, completion: nil)
    }
}
