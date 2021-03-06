//
//  GameViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import Combine
import CombineDataSources
import Madog
import UIKit

private let cellIdentifier = String(describing: DominoCell.self)

class GameViewController: UIViewController {
    private let viewModel: GameViewModel
    private weak var context: Context?

    private lazy var gameView = GameView(frame: .zero, numberOfTrains: viewModel.totalPlayerCount)
    private var subscriptions = [AnyCancellable]()

    init(viewModel: GameViewModel, context: Context) {
        self.viewModel = viewModel
        self.context = context
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

        viewModel.delegate = self

        viewModel.currentPlayerTurn.sink { [weak self] isCurrent in self?.gameView.playerDominoes.backgroundColor = isCurrent ? .green : .white }
            .store(in: &subscriptions)

        subscribe(to: viewModel.playerDominoes, collectionView: gameView.playerDominoes.collectionView)

        viewModel.stationValue.sink { [weak self] in self?.gameView.boardView.stationDominoView.state = $0 }
            .store(in: &subscriptions)

        gameView.boardView.mexicanTrain.collectionView.dropDelegate = self
        subscribe(to: viewModel.mexicanTrain, dominoesView: gameView.boardView.mexicanTrain)

        gameView.boardView.playerTrains.enumerated().forEach {
            let index = $0.offset
            let dominoesView = $0.element

            dominoesView.collectionView.dropDelegate = self
            let trainPublisher = viewModel.train(for: index)
            subscribe(to: trainPublisher, dominoesView: dominoesView)

            dominoesView.trainButton.tag = index
            dominoesView.trainButton.addTarget(self, action: #selector(trainButtonTapped), for: .touchUpInside)
        }

        gameView.playerDominoes.collectionView.dragDelegate = self
        gameView.playerDominoes.collectionView.dragInteractionEnabled = true

        gameView.playerDominoes.collectionView.dragDelegate = self
        gameView.playerDominoes.collectionView.dragInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickupTapped))
        gameView.pickupView.addGestureRecognizer(tapGestureRecognizer)
    }

    private func subscribe(to publisher: AnyPublisher<[DominoView.State], Never>, collectionView: UICollectionView) {
        collectionView.register(DominoCell.self, forCellWithReuseIdentifier: cellIdentifier)

        let controller = CollectionViewItemsController<[[DominoView.State]]>(cellIdentifier: cellIdentifier,
                                                                             cellType: DominoCell.self) { cell, _, state in
            cell.dominoView.state = state
        }

        publisher
            .bind(subscriber: collectionView.itemsSubscriber(controller))
            .store(in: &subscriptions)
    }

    private func subscribe(to publisher: AnyPublisher<TrainState, Never>, dominoesView: PlayedDominoesView) {
        publisher.map { $0.isPlayable }
            .removeDuplicates()
            .sink { isPlayable in dominoesView.trainButton.isHidden = !isPlayable }
            .store(in: &subscriptions)

        let dominoesPublisher = publisher
            .map { $0.dominoes }
            .removeDuplicates()
            .eraseToAnyPublisher()
        subscribe(to: dominoesPublisher, collectionView: dominoesView.collectionView)
    }

    @objc private func pickupTapped(_ sender: UITapGestureRecognizer) {
        viewModel.pickUp { print($0) }
    }

    @objc private func trainButtonTapped(_ sender: UIButton) {
        viewModel.pickUpTrain(at: sender.tag) { print($0) }
    }
}

extension GameViewController: GameViewModelDelegate {
    func gameViewModel(_ viewModel: GameViewModel, levelDidFinish dominoValue: DominoValue) {
        let token: MadogToken
        if let nextLevel = dominoValue.nextValue {
            token = .lobby(nextLevel)
        } else {
            token = .welcome // TODO: Game summary
        }
        context?.navigate(to: token)
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
        guard let destinationTrain = destinationTrain(for: collectionView),
            let item = session.items.first,
            let indexPath = item.localObject as? IndexPath,
            viewModel.canPlayDomino(at: indexPath.row, on: destinationTrain) else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }

        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("Function: \(#function), line: \(#line)")
        guard let destinationTrain = destinationTrain(for: collectionView),
            let item = coordinator.items.first,
            let indexPath = item.dragItem.localObject as? IndexPath else {
            return
        }

        viewModel.playDomino(at: indexPath.row, on: destinationTrain) { print($0) }
    }

    private func destinationTrain(for collectionView: UICollectionView) -> DestinationTrain? {
        if let trainIndex = gameView.boardView.indexOfTrainCollectionView(collectionView) {
            return .player(trainIndex)
        } else if collectionView == gameView.boardView.mexicanTrain.collectionView {
            return .mexican
        }
        return nil
    }
}

private extension IndexPath {
    func toItemProvider() -> NSItemProvider {
        let object = String(row) as NSString
        return NSItemProvider(object: object)
    }
}
