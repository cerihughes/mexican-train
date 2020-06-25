//
//  LobbyPlayerView.swift
//  MexicanTrain
//
//  Created by Home on 23/06/2020.
//

import UIKit

class LobbyPlayerView: SuperView {
    enum State: Equatable {
        case waiting(String?)
        case active(String?)
        case ready(String)
    }

    let name = UILabel.create()
    let status = UILabel.create(size: 14, weight: .regular)
    let button = UIButton(type: .roundedRect)

    override func commonInit() {
        backgroundColor = .white

        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.titleLabel?.textColor = .black
        button.setTitle("Ready", for: .normal)
        button.isHidden = true

        addSubview(name)
        addSubview(status)
        addSubview(button)

        name.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(4)
            make.trailing.equalTo(button.snp.leading)
        }

        status.snp.makeConstraints { make in
            make.leading.trailing.equalTo(name)
            make.top.equalTo(name.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(4)
        }

        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(4)
            make.centerY.equalToSuperview()
        }
    }

    var state: State? {
        didSet {
            name.text = state?.name
            status.text = state?.message
            button.isHidden = state?.isButtonHidden ?? true
        }
    }
}

private extension UILabel {
    static func create(size: CGFloat = 16, weight: UIFont.Weight = .semibold) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: size, weight: weight)
        label.textColor = .black
        return label
    }
}

private extension LobbyPlayerView.State {
    var message: String {
        switch self {
        case .waiting: return "Waiting..."
        case .active: return "PRESS READY BUTTON TO CONFIRM"
        case .ready: return "Ready!"
        }
    }

    var name: String? {
        switch self {
        case let .waiting(name): return name
        case let .active(name): return name
        case let .ready(name): return name
        }
    }

    var isButtonHidden: Bool {
        switch self {
        case .active: return false
        default: return true
        }
    }
}
