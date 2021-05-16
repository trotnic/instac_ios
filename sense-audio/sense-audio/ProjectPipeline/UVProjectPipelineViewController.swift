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

    private var pipelineViewModel: UVProjectPipelineViewModelType!

    private lazy var createTrackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(.newTrack, point: .navigationButton), for: .normal)
        return button
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(.play, point: .navigationButton), for: .normal)
        return button
    }()

    @IBOutlet weak var tableView: UITableView!
}

// MARK: - Public interface

extension UVProjectPipelineViewController {
    static func instantiate(_ viewModel: UVProjectPipelineViewModelType) -> UVProjectPipelineViewController {
        let controller = UVProjectPipelineViewController(nibName: String(describing: self), bundle: nil)
        controller.pipelineViewModel = viewModel
        return controller
    }
}

// MARK: - UIViewController overrides

extension UVProjectPipelineViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        bindViews()
        setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pipelineViewModel.requestContents()
    }
}

// MARK: - Private interface

private extension UVProjectPipelineViewController {
    func bindToViewModel() {
        pipelineViewModel
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
        createTrackButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.pipelineViewModel.addTrack()
            }

        playButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.pipelineViewModel.play()
            }
    }

    func setupAppearance() {
        let playBarItem = UIBarButtonItem(customView: playButton)
        playButton.isEnabled = false
        navigationItem.rightBarButtonItems = [
            playBarItem,
            UIBarButtonItem(customView: createTrackButton)
        ]
        setupTableView()
    }

    func setupTableView() {
        tableView.register(UVPipelineTrackTableCell.instantiateNib(), forCellReuseIdentifier: Constants.cellIdentifier)
    }
}

// MARK: - UITableViewDelegate

extension UVProjectPipelineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pipelineViewModel.editTrack(at: indexPath.row)
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

            cell.trackLabel.text = track.name

            cell.editButton.reactive
                .controlEvents(.touchUpInside)
                .observeValues { (_) in
                    self.pipelineViewModel.editTrack(at: indexPath.row)
                }
            return cell
        }
        return UITableViewCell()
    }
}
