//
//  AuthenticateGameViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 12/06/2020.
//

import Madog
import UIKit

class AuthenticateGameViewController: UIViewController {
    private let viewModel: AuthenticateGameViewModel
    private weak var context: ForwardBackNavigationContext?

    init(viewModel: AuthenticateGameViewModel, context: ForwardBackNavigationContext) {
        self.viewModel = viewModel
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let context = context else { return }
        viewModel.authenticate(context: context) { [weak self] viewController in
            self?.present(viewController, animated: true)
        }
    }
}
