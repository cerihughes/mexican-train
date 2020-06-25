//
//  LobbyViewModel.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Combine
import Foundation

protocol LobbyViewModelDelegate: AnyObject {
    func lobbyViewModelIsReadyToPlay(_ viewModel: LobbyViewModel)
}

protocol LobbyViewModel {
    var delegate: LobbyViewModelDelegate? { get nonmutating set }
    var totalPlayerCount: Int { get }

    func lobbyState(for player: Int) -> LobbyPlayerView.State
    func lobbyStatePublisher(for player: Int) -> AnyPublisher<LobbyPlayerView.State, Never>
    func ready(completion: @escaping (Bool) -> Void)
}

class LobbyViewModelImpl: AbstractGameViewModelImpl, LobbyViewModel {
    private let stationValue: DominoValue
    private var subscription: AnyCancellable?

    weak var delegate: LobbyViewModelDelegate?

    init(stationValue: DominoValue, gameEngine: GameEngine, operations: Operations) {
        self.stationValue = stationValue
        super.init(gameEngine: gameEngine, operations: operations)

        subscription = gameEngine.gamePublisher.sink { [weak self] game in
            guard let self = self else { return }
            if game.players.count == self.totalPlayerCount {
                if gameEngine.engineState.localPlayerIsCurrentPlayer, game.players.allSatisfy({ player in player.dominoes.isEmpty }) {
                    let update = operations.startLevel.perform(game: self.latestGame, stationValue: stationValue)
                    gameEngine.update(game: update) { [weak self] _ in
                        self?.closeLobby()
                    }
                } else {
                    self.closeLobby()
                }
            }
        }
        gameEngine.refresh()
        startRefreshTimer()
    }

    func lobbyState(for player: Int) -> LobbyPlayerView.State {
        gameEngine.engineState.lobbyState(for: player, game: latestGame)
    }

    func lobbyStatePublisher(for player: Int) -> AnyPublisher<LobbyPlayerView.State, Never> {
        gameEngine.gamePublisher
            .compactMap { [weak self] _ in self?.lobbyState(for: player) }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    func ready(completion: @escaping (Bool) -> Void) {
        guard gameEngine.engineState.localPlayerIsCurrentPlayer else {
            completion(false)
            return
        }

        let update = operations.joinGame.perform(game: latestGame)
        gameEngine.endTurn(game: update, completion: completion)
    }

    private func closeLobby() {
        subscription?.cancel()
        delegate?.lobbyViewModelIsReadyToPlay(self)
    }
}

private extension EngineState {
    func lobbyState(for player: Int, game: Game) -> LobbyPlayerView.State {
        if localPlayerIsCurrentPlayer, player == localPlayerIndex {
            if let localPlayerDetails = localPlayerDetails, game.player(id: localPlayerDetails.id) != nil {
                return .ready(localPlayerDetails.name)
            } else {
                return .active(localPlayerDetails?.name)
            }
        }

        let otherPlayerDetails = playerDetails[safe: player]
        if let otherPlayerDetails = otherPlayerDetails, game.player(id: otherPlayerDetails.id) != nil {
            return .ready(otherPlayerDetails.name)
        }

        return .waiting(otherPlayerDetails?.name)
    }
}
