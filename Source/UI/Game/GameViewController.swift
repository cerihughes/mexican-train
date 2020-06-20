//
//  GameViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import CombineDataSources
import UIKit

private let cellIdentifier = String(describing: DominoCell.self)

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

        viewModel.currentPlayerTurn.sink { [weak self] isCurrent in self?.gameView.playerDominoes.backgroundColor = isCurrent ? .green : .white }
            .store(in: &subscriptions)

        subscribe(to: viewModel.playerDominoes, collectionView: gameView.playerDominoes.collectionView)
            .store(in: &subscriptions)
        gameView.playerTrains.enumerated().forEach {
            let index = $0.offset
            let dominoesView = $0.element

            dominoesView.collectionView.dropDelegate = self
            if let trainPublisher = viewModel.train(for: index) {
                subscribe(to: trainPublisher, collectionView: dominoesView.collectionView)
                    .store(in: &subscriptions)
            }
        }

        gameView.playerDominoes.collectionView.dragDelegate = self
        gameView.playerDominoes.collectionView.dragInteractionEnabled = true

        gameView.playerDominoes.collectionView.dragDelegate = self
        gameView.playerDominoes.collectionView.dragInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickupTapped))
        gameView.pickupView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func subscribe(to publisher: AnyPublisher<[DominoView.State], Never>, collectionView: UICollectionView) -> AnyCancellable {
        collectionView.register(DominoCell.self, forCellWithReuseIdentifier: cellIdentifier)

        let controller = CollectionViewItemsController<[[DominoView.State]]>(cellIdentifier: cellIdentifier,
                                                                             cellType: DominoCell.self) { cell, _, state in
            cell.dominoView.state = state
        }

        return publisher.bind(subscriber: collectionView.itemsSubscriber(controller))
    }

    @objc private func pickupTapped(_ sender: UITapGestureRecognizer) {
        viewModel.pickup { print($0) }
    }
}

extension GameViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        print("Function: \(#function), line: \(#line)")
        let dragItem = UIDragItem(itemProvider: indexPath.toItemProvider())
        dragItem.localObject = indexPath
        return [dragItem]
    }
}

extension GameViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        dropSessionDidUpdate session: UIDropSession,
                        withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        print("Function: \(#function), line: \(#line)")
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("Function: \(#function), line: \(#line)")
        guard let item = coordinator.items.first, let indexPath = item.dragItem.localObject as? IndexPath else {
            return
        }

        viewModel.playDomino(at: indexPath.row) { print($0) }
    }
}

private extension IndexPath {
    func toItemProvider() -> NSItemProvider {
        let object = String(row) as NSString
        return NSItemProvider(object: object)
    }
}
