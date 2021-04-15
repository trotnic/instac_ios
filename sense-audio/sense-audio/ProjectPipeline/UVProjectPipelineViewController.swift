//
//  UVProjectPipelineViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import UIKit

class UVProjectPipelineViewController: UIViewController {

    private struct Constants {
        static let cellIdentifier = "cell"
    }
    
    // MARK: - Props
    
    private var pipelineViewModel: UVProjectPipelineViewModelType
    
    private lazy var createTrackButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(createTrack(_:)))
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        view.dataSource = self
        return view
    }()
    
    // MARK: - Initialization
    
    init(pipeline pipeViewModel: UVProjectPipelineViewModelType) {
        pipelineViewModel = pipeViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
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
        pipelineViewModel.addTrack()
    }
}

extension UVProjectPipelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pipelineViewModel.numberOfElements()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = pipelineViewModel.content(at: indexPath.row)
        return cell
    }
}
