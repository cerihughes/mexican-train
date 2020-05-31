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
        subscribe(to: viewModel.player2Dominoes, collectionView: gameView.player2Dominoes.collectionView)
            .store(in: &subscriptions)

        viewModel.reload()
    }

    private func subscribe(to publisher: AnyPublisher<[UnplayedDomino], Never>, collectionView: UICollectionView) -> AnyCancellable {
        collectionView.register(DominoCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)

        let controller = CollectionViewItemsController<[[UnplayedDomino]]>(cellIdentifier: cellIdentifier,
                                                                           cellType: DominoCollectionViewCell.self) { cell, _, domino in
            cell.dominoView.state = domino.faceUpState
        }

        return publisher.bind(subscriber: collectionView.itemsSubscriber(controller))
    }
}

private extension UnplayedDomino {
    var faceUpState: DominoView.State {
        .faceUp(value1.viewValue, value2.viewValue)
    }
}

private extension DominoValue {
    var viewValue: DominoFaceView.Value {
        switch self {
        case .zero: return .zero
        case .one: return .one
        case .two: return .two
        case .three: return .three
        case .four: return .four
        case .five: return .five
        case .six: return .six
        case .seven: return .seven
        case .eight: return .eight
        case .nine: return .nine
        case .ten: return .ten
        case .eleven: return .eleven
        case .twelve: return .twelve
        }
    }
}
