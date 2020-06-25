//
//  StartGameViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import GameKit
import Madog
import UIKit

class StartGameViewController: UIViewController {
    private let viewModel: StartGameViewModel
    private weak var context: Context?

    init(viewModel: StartGameViewModel, context: Context) {
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
        let matchRequest = createMatchRequest()
        let viewController = GKTurnBasedMatchmakerViewController(matchRequest: matchRequest)
        viewController.turnBasedMatchmakerDelegate = self
        present(viewController, animated: true)
    }

    private func createMatchRequest() -> GKMatchRequest {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 4
        request.inviteMessage = "Would you like to play Mexican Train?"
        return request
    }
}

extension StartGameViewController: GKTurnBasedMatchmakerViewControllerDelegate {
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }

    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {}
}

extension StartGameViewController: StartGameViewModelDelegate {
    func startGameViewModel(_ viewModel: StartGameViewModel, navigateTo token: MadogToken) {
        print("Function: \(#function), line: \(#line)")
        dismiss(animated: true)
        context?.navigate(to: token)
    }
}
