//
//  WelcomeViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 14/06/2020.
//

import Madog
import UIKit

class WelcomeViewController: UIViewController {
    private let viewModel: WelcomeViewModel
    private weak var context: ForwardBackNavigationContext?

    private lazy var welcomeView = WelcomeView()

    init(viewModel: WelcomeViewModel, context: ForwardBackNavigationContext) {
        self.viewModel = viewModel
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = welcomeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeView.label.text = viewModel.authenticatingMessage
        welcomeView.button.isEnabled = false
        welcomeView.button.setTitle(viewModel.buttonTitle, for: .normal)
        welcomeView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

        viewModel.authenticate { [weak self] viewController, isAuthenticated in
            guard let self = self else { return }
            if isAuthenticated {
                self.welcomeView.label.text = self.viewModel.authenticatedMessage
                self.welcomeView.button.isEnabled = true
            } else if let viewController = viewController {
                self.present(viewController, animated: true)
            } else {
                self.welcomeView.label.text = self.viewModel.authenticatingErrorMessage
            }
        }
    }

    @objc
    private func buttonTapped(_ sender: UIButton) {
        context?.navigateForward(token: MadogToken.newGame, animated: true)
    }
}
