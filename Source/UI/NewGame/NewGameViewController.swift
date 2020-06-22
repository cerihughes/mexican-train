//
//  NewGameViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import GameKit
import Madog
import UIKit

class NewGameViewController: UIViewController {
    private let viewModel: NewGameViewModel
    private weak var context: ForwardBackNavigationContext?

    init(viewModel: NewGameViewModel, context: ForwardBackNavigationContext) {
        self.viewModel = viewModel
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        let matchRequest = viewModel.createMatchRequest()
        let viewController = GKTurnBasedMatchmakerViewController(matchRequest: matchRequest)
        viewController.turnBasedMatchmakerDelegate = self
        present(viewController, animated: true)
    }
}

extension NewGameViewController: GKTurnBasedMatchmakerViewControllerDelegate {
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }

    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {}
}

extension NewGameViewController: NewGameViewModelDelegate {
    func newGameViewModel(_ viewModel: NewGameViewModel, didResumeGame totalPlayerCount: Int) {
        print("Function: \(#function), line: \(#line)")
        dismiss(animated: true)
        context?.navigateForward(token: MadogToken.playGame(totalPlayerCount), animated: true)
    }

    func newGameViewModel(_ viewModel: NewGameViewModel, didStartGame totalPlayerCount: Int) {
        print("Function: \(#function), line: \(#line)")
        dismiss(animated: true)
        context?.navigateForward(token: MadogToken.playGame(totalPlayerCount), animated: true)
    }

    func newGameViewModelDidFailToStartGame(_ viewModel: NewGameViewModel) {
        print("Function: \(#function), line: \(#line)")
    }
}
