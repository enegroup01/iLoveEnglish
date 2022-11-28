//
//  CardView.swift
//  iLoveEnglish
//
//  Created by ethan on 2022/11/26.
//

import UIKit

class LoveEnglishCardView: UIView {
    let wordLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIConfig.wordSize)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let chineseLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIConfig.chineseSize)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let loveButton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(named: "basicLove")?.applyImageColor(tintColor: .cyan), for: .normal)
        return button
    }()
    
    private var loveWord = LoveEnglishLiveData<LoveEnglishWord>(LoveEnglishWord())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

private extension LoveEnglishCardView {
    func commonInit() {
        setupUI()
        binding()
    }
    
    func setupUI() {
        backgroundColor = .systemPink
        layer.cornerRadius = UIConfig.cornerRadius
        
        addSubview(wordLabel)
        wordLabel
            .setAnchor(\.topAnchor, .equal, to: topAnchor, constant: UIConfig.anchorConst)
            .setAnchor(\.leftAnchor, .equal, to: leftAnchor, constant: UIConfig.anchorConst)
            .setAnchor(\.rightAnchor, .equal, to: rightAnchor, constant: -UIConfig.anchorConst)
            .setAnchor(\.heightAnchor, .equal, constant: UIConfig.wordLabelHeight)
        
        addSubview(chineseLabel)
        chineseLabel
            .setAnchor(\.topAnchor, .equal, to: wordLabel.bottomAnchor, constant: UIConfig.anchorConst)
            .setAnchor(\.leftAnchor, .equal, to: leftAnchor, constant: UIConfig.anchorConst)
            .setAnchor(\.rightAnchor, .equal, to: rightAnchor, constant: -UIConfig.anchorConst)
            .setAnchor(\.heightAnchor, .equal, constant: UIConfig.chineseLabelHeight)
        
        addSubview(loveButton)
        loveButton
            .setAnchor(\.bottomAnchor, .equal, to: bottomAnchor, constant: -UIConfig.buttonBottomConst)
            .setAnchor(\.centerXAnchor, .equal, to: centerXAnchor)
            .setAnchor(\.widthAnchor, .equal, constant: UIConfig.buttonSize)
            .setAnchor(\.heightAnchor, .equal, constant: UIConfig.buttonSize)
        
            
    }
    
    func binding() {
        loveWord.addAndNotify(observer: self) {[weak self] word in
            self?.wordLabel.text = word.word
            self?.chineseLabel.text = word.chinese
        }
    }
}

extension LoveEnglishCardView {
    func update(word: LoveEnglishWord) {
        loveWord.just(word)
    }
}

private extension LoveEnglishCardView {
    struct UIConfig {
        static let anchorConst: CGFloat = 10
        static let wordLabelHeight: CGFloat = 100
        static let cornerRadius: CGFloat = 10
        static let wordSize: CGFloat = 80
        static let chineseSize: CGFloat = 30
        static let chineseLabelHeight: CGFloat = 60
        static let buttonSize: CGFloat = 50
        static let buttonBottomConst: CGFloat = 20
    }
}


