//
//  LoveEnglishBarView.swift
//  iLoveEnglish
//
//  Created by ethan on 2022/11/29.
//

import Foundation
import UIKit

class LoveEnglishBarView: UIView {
    var barStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .darkGray
        stackView.spacing = UIConfig.spacing
        stackView.layer.cornerRadius = UIConfig.cornerRadius
        return stackView
    }()
    
    private var cardIndex = LoveEnglishLiveData<Int>(0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

private extension LoveEnglishBarView {
    func commonInit() {
        setupUI()
        binding()
    }
    
    func setupUI() {
        addSubview(barStackView)
        barStackView
            .setAnchor(\.leftAnchor, .equal, to: leftAnchor)
            .setAnchor(\.rightAnchor, .equal, to: rightAnchor)
            .setAnchor(\.topAnchor, .equal, to: topAnchor)
            .setAnchor(\.bottomAnchor, .equal, to: bottomAnchor)
        let view = UIView()
        view.backgroundColor = .white
        let view1 = UIView()
        view1.backgroundColor = .lightGray
        let view2 = UIView()
        view2.backgroundColor = .lightGray
        barStackView.addArrangedSubview(view)
        barStackView.addArrangedSubview(view1)
        barStackView.addArrangedSubview(view2)
    }
    
    func binding() {
        cardIndex.addObserver(self) { [weak self] index in
            guard let self = self else { return }
            self.handleAdjustBar(index: index)
        }
    }
}

extension LoveEnglishBarView {
    func adjustBar(index: Int) {
        cardIndex.just(index)
    }
    
    private func handleAdjustBar(index: Int) {
        switch index {
        case 0:
            barStackView.arrangedSubviews[0].backgroundColor = .white
            barStackView.arrangedSubviews[1].backgroundColor = .lightGray
            barStackView.arrangedSubviews[2].backgroundColor = .lightGray
        case 1:
            barStackView.arrangedSubviews[0].backgroundColor = .white
            barStackView.arrangedSubviews[1].backgroundColor = .white
            barStackView.arrangedSubviews[2].backgroundColor = .lightGray
        case 2:
            barStackView.arrangedSubviews.forEach({$0.backgroundColor = .white})
        default:
            return
        }
    }
}

private extension LoveEnglishBarView {
    struct UIConfig {
        static let barColorAlpha: CGFloat = 0.5
        static let cornerRadius: CGFloat = 3
        static let spacing: CGFloat = 3
    }
}
