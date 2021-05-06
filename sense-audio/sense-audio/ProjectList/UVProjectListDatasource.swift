//
//  UVProjectListDatasource.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      02.05.2021
//

import UIKit

protocol UVProjectListDatasourceType: UITableViewDataSource {
    var contents: [String] { get set }
    func setup(tableView: UITableView)
}

final class UVProjectListDatasource: NSObject {
    private struct Constants {
        static let cellIdentifier = "cell"
    }

    var contents: [String] = []
    private var tableView: UITableView?
}

extension UVProjectListDatasource: UVProjectListDatasourceType {

    func setup(tableView: UITableView) {
        self.tableView = tableView
        self.tableView?.dataSource = self

        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = contents[indexPath.row]
        return cell
    }
}
