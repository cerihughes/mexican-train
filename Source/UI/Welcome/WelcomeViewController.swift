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

    init(viewModel: WelcomeViewModel, context: ForwardBackNavigationContext) {
        self.viewModel = viewModel
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
