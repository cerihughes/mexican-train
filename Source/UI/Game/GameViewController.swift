//
//  GameViewController.swift
//  MexicanTrain
//
//  Created by Ceri on 31/05/2020.
//

import UIKit

class GameViewController: UIViewController {
    private let viewModel: GameViewModel

    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
