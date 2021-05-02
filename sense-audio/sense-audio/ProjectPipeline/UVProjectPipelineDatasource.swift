//
//  UVProjectPipelineDatasource.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      02.05.2021
//

import UIKit
import ReactiveSwift

protocol UVProjectPipelineDatasourceType {
    var contents: [String] { get set }
    func setup(tableView: UITableView)
}

final class UVProjectPipelineDatasource: NSObject {
    private struct Constants {
        static let cellIdentifier = "cell"
    }

    var contents: [String] = []
    private var tableView: UITableView?
    private var identifier = ""
}

extension UVProjectPipelineDatasource: UVProjectPipelineDatasourceType {
    func setup(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.dataSource = self

        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
}

extension UVProjectPipelineDatasource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = contents[indexPath.row]
        return cell
    }
}
