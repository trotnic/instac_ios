//
//  UVRecordingListViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      1.04.21
//

import UIKit

class UVRecordingListViewController: UIViewController {
    
    struct Constants {
        static let reuseIdentifier = "cell"
        static let addIconName = "plus"
    }
    
    var presenter: UVRecordListType = UVRecordListPresenter()
    
    var contents: [URL] = []
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: Constants.reuseIdentifier)
        return view
    }()
    
    lazy var createAssetButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: Constants.addIconName), for: .normal)
        view.addTarget(self, action: #selector(showCreationController), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: createAssetButton)
        ]
        layoutTableView()
    }
    
    private func layoutTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

extension UVRecordingListViewController {
    @objc func showCreationController() {
        navigationController?.pushViewController(UVRecordingViewController(), animated: true)
    }
}

extension UVRecordingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = presenter.path(indexPath.row)
        return cell
    }
}

extension UVRecordingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [presenter] (action, view, completion) in
        
            // MARK: ⚠️ DEVELOP ZONE ⚠️
            presenter.delete(indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
            completion(true)
        }
        return .init(actions: [action])
    }
}
