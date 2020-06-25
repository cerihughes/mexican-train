//
//  LobbyView.swift
//  MexicanTrain
//
//  Created by Ceri on 22/06/2020.
//

import UIKit

class LobbyView: UIView {
    private let stackView = UIStackView()
    var playerViews = [LobbyPlayerView]()

    init(frame: CGRect, numberOfPlayers: Int) {
        playerViews = (0 ..< numberOfPlayers)
            .map { _ in LobbyPlayerView() }

        super.init(frame: frame)

        commonInit(numberOfPlayers: numberOfPlayers)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit(numberOfPlayers: Int) {
        backgroundColor = .white

        stackView.axis = .vertical
        stackView.distribution = .equalCentering

        addSubview(stackView)

        playerViews.forEach { stackView.addArrangedSubview($0) }

        stackView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
