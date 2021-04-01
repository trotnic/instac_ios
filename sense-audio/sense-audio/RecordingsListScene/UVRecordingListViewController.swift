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
    }
    
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
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        view.addTarget(self, action: #selector(showCreationController), for: .touchUpInside)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupContents()
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
    
    private func setupContents() {
        // MARK: ⚠️ DEVELOP ZONE ⚠️
        if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
           let contents = try? FileManager.default.contentsOfDirectory(atPath: directoryURL.path) {
            self.contents.append(contentsOf: contents.compactMap({ URL(string: $0) }))
        }
    }
    
}

extension UVRecordingListViewController {
    @objc func showCreationController() {
        navigationController?.pushViewController(UVRecordingViewController(), animated: true)
    }
}

extension UVRecordingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = contents[indexPath.row].lastPathComponent
        return cell
    }
}

extension UVRecordingListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
        
            // MARK: ⚠️ DEVELOP ZONE ⚠️
            tableView.deselectRow(at: indexPath, animated: true)
            completion(true)
        }
        return .init(actions: [action])
    }
}
