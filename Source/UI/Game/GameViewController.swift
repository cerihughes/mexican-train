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
    private lazy var gameView = GameView(frame: .zero, numberOfTrains: viewModel.totalPlayerCount)
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

        subscribe(to: viewModel.playerDominoes, collectionView: gameView.playerDominoes.collectionView)
            .store(in: &subscriptions)
        gameView.playerTrains.enumerated().forEach {
            if let trainPublisher = viewModel.train(for: $0.offset) {
                subscribe(to: trainPublisher, collectionView: $0.element.collectionView)
                    .store(in: &subscriptions)
            }
        }

        gameView.playerDominoes.collectionView.delegate = self
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

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Function: \(#function), line: \(#line)")
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.playDomino(at: indexPath.row) { print($0) }
    }
}
