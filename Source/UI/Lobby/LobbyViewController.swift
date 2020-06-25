//
//  LobbyViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Combine
import Madog
import UIKit

class LobbyViewController: UIViewController {
    private let viewModel: LobbyViewModel
    private weak var context: Context?
    private var subscriptions = [AnyCancellable]()

    private lazy var lobbyView = LobbyView(frame: .zero, numberOfPlayers: viewModel.totalPlayerCount)

    init(viewModel: LobbyViewModel, context: Context) {
        self.viewModel = viewModel
        self.context = context

        super.init(nibName: nil, bundle: nil)

        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = lobbyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        lobbyView.playerViews.enumerated().forEach {
            let index = $0.offset
            let lobbyPlayerView = $0.element

            lobbyPlayerView.state = viewModel.lobbyState(for: index)
            subscribe(to: viewModel.lobbyStatePublisher(for: index), lobbyPlayerView: lobbyPlayerView)

            lobbyPlayerView.button.tag = index
            lobbyPlayerView.button.addTarget(self, action: #selector(readyButtonTapped), for: .touchUpInside)
        }
    }

    private func subscribe(to publisher: AnyPublisher<LobbyPlayerView.State, Never>, lobbyPlayerView: LobbyPlayerView) {
        publisher
            .sink { lobbyPlayerView.state = $0 }
            .store(in: &subscriptions)
    }

    @objc private func readyButtonTapped(_ sender: UIButton) {
        viewModel.ready { print($0) }
    }
}

extension LobbyViewController: LobbyViewModelDelegate {
    func lobbyViewModelIsReadyToPlay(_ viewModel: LobbyViewModel) {
        context?.navigate(to: .gameTest)
    }
}
