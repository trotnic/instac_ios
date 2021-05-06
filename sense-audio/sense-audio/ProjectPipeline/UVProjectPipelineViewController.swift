//
//  UVProjectPipelineViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import UIKit
import ReactiveSwift

class UVProjectPipelineViewController: UIViewController {

    private struct Constants {

    }

    // MARK: - Props

    private var pipelineViewModel: UVProjectPipelineViewModelType
    private var dataSource: UVProjectPipelineDatasourceType

    private lazy var createTrackButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(createTrack(_:)))
        return button
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Initialization

    init(pipeline pipeViewModel: UVProjectPipelineViewModelType, data source: UVProjectPipelineDatasourceType) {
        pipelineViewModel = pipeViewModel
        dataSource = source
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()

        dataSource.setup(tableView: tableView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: ♻️ REFACTOR LATER ♻️
        pipelineViewModel
            .contents
            .on(value: { [tableView] contents in
                self.dataSource.contents = contents
                tableView.reloadData()
            })
            .start()
    }

}

private extension UVProjectPipelineViewController {
    func setupAppearance() {
        navigationItem.rightBarButtonItems = [
            createTrackButton
        ]
        layoutTableView()
    }

    func layoutTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func createTrack(_ sender: UIBarButtonItem) {
        pipelineViewModel
            .addTrack()
            .on(value: { _ in
                print("checkcheck")
            })
            .start()
    }
}

// MARK: - UITableViewDelegate

extension UVProjectPipelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [pipelineViewModel] (_, _, completion) in
            // MARK: ♻️ REFACTOR LATER ♻️
            self.pipelineViewModel
                .delete(at: indexPath.row)
                .combineLatest(with: pipelineViewModel.contents.promoteError())
                .on(value: { _, contents in
                    self.dataSource.contents = contents
                    tableView.reloadSections(IndexSet([0]), with: .fade)
                    completion(true)
                })
                .start()
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        pipelineViewModel
            .didSelect(at: indexPath.row)
            .start()
    }
}
