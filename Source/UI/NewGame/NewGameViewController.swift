//
//  NewGameViewController.swift
//  MexicanTrain
//
//  Created by Home on 12/06/2020.
//

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
}
