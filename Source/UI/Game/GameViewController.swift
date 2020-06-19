//
//  GameViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import CombineDataSources
import UIKit

private let cellIdentifier = String(describing: DominoCollectionViewCell.self)

class GameViewController: UIViewController {
    private let viewModel: GameViewModel
    private lazy var gameView = GameView()
    private var subscriptions = [AnyCancellable]()

    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = gameView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe(to: viewModel.player1Dominoes, collectionView: gameView.player1Dominoes.collectionView)
            .store(in: &subscriptions)
        subscribe(to: viewModel.player1Train, collectionView: gameView.player1Train.collectionView)
            .store(in: &subscriptions)
        subscribe(to: viewModel.player2Train, collectionView: gameView.player1Train.collectionView)
            .store(in: &subscriptions)

        viewModel.reload()
    }

    private func subscribe(to publisher: AnyPublisher<[DominoView.State], Never>, collectionView: UICollectionView) -> AnyCancellable {
        collectionView.register(DominoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)

        let controller = CollectionViewItemsController<[[DominoView.State]]>(cellIdentifier: cellIdentifier,
                                                                             cellType: DominoCollectionViewCell.self) { cell, _, state in
            cell.dominoView.state = state
        }

        return publisher.bind(subscriber: collectionView.itemsSubscriber(controller))
    }
}
