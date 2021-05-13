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
        static let reuseIdentifier = "cell"
    }

    // MARK: - Props

    @IBOutlet weak var tableView: UITableView!

    private let addTrackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(.newTrack, point: 20), for: .normal)
        return button
    }()

    private let numberOfItems: MutableProperty<Int> = MutableProperty(0)
    private let contents: MutableProperty<[String]> = MutableProperty([])

    private var listViewModel: UVProjectListViewModelType!
}

// MARK: - Public interface

extension UVProjectListViewController {
    static func instantiate(_ viewModel: UVProjectListViewModelType) -> UVProjectListViewController {
        let controller = UVProjectListViewController(nibName: String(describing: self), bundle: nil)
        controller.listViewModel = viewModel
        return controller
    }
}

// MARK: - UIViewController overrides

extension UVProjectListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        bindViews()
        setupTableView()
        setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listViewModel.requestContents()
    }
}

// MARK: - Private interface

private extension UVProjectListViewController {
    func bindToViewModel() {
        listViewModel
            .contents
            .observeResult({ [self] result in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let value):
                    numberOfItems.value = value.count
                    contents.value = value
                    tableView.reloadSections(IndexSet([0]), with: .automatic)
                }
            })
    }

    func bindViews() {
        addTrackButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.showNewProjectModal()
            }
    }

    func setupAppearance() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: addTrackButton)
        ]
        navigationItem.title = "Projects"
    }

    func setupTableView() {
        tableView.register(UVProjectListTableCell.instantiateNib(), forCellReuseIdentifier: Constants.reuseIdentifier)
    }

    func showNewProjectModal() {
        let creationDialog = UIAlertController(title: "New project",
                                               message: "Select a name for your project",
                                               preferredStyle: .alert)

        creationDialog.addTextField { (textField) in
            textField.placeholder = "Project name"
        }

        creationDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in

        }))

        creationDialog.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            if let projectName = creationDialog.textFields?.first?.text {
                self.listViewModel?.create(project: projectName)
            }
        }))

        present(creationDialog, animated: true)
    }

    func showProjectActionSheet(for index: Int) {
        let project = contents.value[index]

        let actionSheet = UIAlertController(title: "Select option for '\(project)'", message: "", preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Rename", style: .default, handler: { [self] _ in
            dismiss(animated: true) {
                showRenameProjectDialog(for: index)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Export", style: .default, handler: { _ in
            // MARK: ♻️ REFACTOR LATER ♻️
        }))
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.listViewModel.delete(at: index)
        }))

        present(actionSheet, animated: true)
    }

    func showRenameProjectDialog(for index: Int) {
        let project = contents.value[index]

        let creationDialog = UIAlertController(title: "Rename \(project)",
                                               message: "Select a new name for your project",
                                               preferredStyle: .alert)

        creationDialog.addTextField { (textField) in
            textField.placeholder = "Project name"
        }

        creationDialog.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in

        }))

        creationDialog.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            if let projectName = creationDialog.textFields?.first?.text {
                self.listViewModel?.rename(at: index, with: projectName)
            }
        }))

        present(creationDialog, animated: true)

    }
}

// MARK: - UITableViewDelegate

extension UVProjectListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        listViewModel.didSelect(itemAt: indexPath.row)
    }
}

// MARK: - UITableViewDatasource

extension UVProjectListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfItems.value
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath) as? UVProjectListTableCell {
            cell.projectLabel.text = contents.value[indexPath.row]
            cell.editButton.reactive
                .controlEvents(.touchUpInside)
                .observeValues { _ in
                    self.showProjectActionSheet(for: indexPath.row)
                }
            return cell
        }
        return UITableViewCell()
    }
}
