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
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        return button
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play"), for: .normal)
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
}

// MARK: - Private interface

private extension UVProjectPipelineViewController {
    func bindToViewModel() {
        contents <~ pipelineViewModel.contents
        numberOfItems <~ pipelineViewModel.contents.map({ $0.count })
    }
    
    func bindViews() {
        createTrackButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.pipelineViewModel
                    .addTrack()
                    .on(value: { _ in
                        // MARK: ♻️ REFACTOR LATER ♻️
                    })
                    .start()
            }
        
        playButton.reactive
            .controlEvents(.touchUpInside)
            .observeValues { _ in
                self.pipelineViewModel.play()
            }
    }

    func setupAppearance() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: playButton),
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
