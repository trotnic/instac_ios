//
//  UVProjectPipelineViewController.swift
//
//  Project: sense-audio
// 
//  Author:  Uladzislau Volchyk
//  On:      14.04.21
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class UVProjectPipelineViewController: UIViewController {

    private struct Constants {
        static let cellIdentifier = "cell"
    }

    // MARK: - Props

    private let numberOfItems: MutableProperty<Int> = MutableProperty(0)
    private let contents: MutableProperty<[UVTrackModel]> = MutableProperty([])

    private var pipelineViewModel: UVProjectPipelineViewModelType

    private lazy var createTrackButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(createTrack(_:)))
        return button
    }()

    private lazy var playButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "play"), style: .plain, target: self, action: #selector(play))
        return button
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(UVPipelineTrackTableCell.instantiateNib(), forCellReuseIdentifier: Constants.cellIdentifier)
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
        bindToViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

private extension UVProjectPipelineViewController {
    func bindToViewModel() {
        contents <~ pipelineViewModel.contents
        numberOfItems <~ pipelineViewModel.contents.map({ $0.count })
    }

    func setupAppearance() {
        navigationItem.rightBarButtonItems = [
            playButton,
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

    @objc func play() {
        pipelineViewModel.play()
    }
}

// MARK: - UITableViewDelegate

extension UVProjectPipelineViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [pipelineViewModel] (_, _, completion) in
//            // MARK: ♻️ REFACTOR LATER ♻️
//            self.pipelineViewModel
//                .delete(at: indexPath.row)
//                .combineLatest(with: pipelineViewModel.contents.promoteError())
//                .on(value: { _, contents in
//                    self.dataSource.contents = contents
//                    tableView.reloadSections(IndexSet([0]), with: .fade)
//                    completion(true)
//                })
//                .start()
//        }
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        pipelineViewModel
//            .didSelect(at: indexPath.row)
//            .start()
    }
}

// MARK: - UITableViewDatasource

extension UVProjectPipelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfItems.value
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as? UVPipelineTrackTableCell {
            let track = contents.value[indexPath.row]
//            cell.volumeSlider.reactive.value <~ track.volume
            track.volume.bindingTarget <~ cell.volumeSlider.reactive.values

            cell.trackLabel.text = track.name
//            track.volume.signal.observeValues { (value) in
//                print(value)
//            }
//            cell.trackLabel.text = contents.value[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
