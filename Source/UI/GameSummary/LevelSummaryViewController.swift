//
//  LevelSummaryViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import Madog
import UIKit

class LevelSummaryViewController: UIViewController {
    private let viewModel: LevelSummaryViewModel
    private weak var context: ForwardBackNavigationContext?

    private lazy var levelSummaryView = LevelSummaryView()

    init(viewModel: LevelSummaryViewModel, context: ForwardBackNavigationContext) {
        self.viewModel = viewModel
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = levelSummaryView
    }
}
