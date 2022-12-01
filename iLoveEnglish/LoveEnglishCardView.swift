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
    
    let sentenceAndTranslationLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.boldSystemFont(ofSize: UIConfig.sentenceAndTranslationSize)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.backgroundColor = .blue
        return label
    }()
    
    let loveButton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(named: "basicLove")?.applyImageColor(tintColor: .cyan), for: .normal)
        return button
    }()
    
    let leftButton: UIButton = {
        let button =  UIButton()
        return button
    }()
    
    let rightButton: UIButton = {
        let button =  UIButton()
        return button
    }()
    

    let barView = LoveEnglishBarView()
    
    private var loveWord = LoveEnglishLiveData<LoveEnglishWord>(LoveEnglishWord())
    
    private var index = LoveEnglishLiveData<Int>(0)
    
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
        
        addSubview(barView)
        barView
            .setAnchor(\.leftAnchor, .equal, to: leftAnchor, constant: UIConfig.barLeftRightConst)
            .setAnchor(\.rightAnchor, .equal, to: rightAnchor, constant: -UIConfig.barLeftRightConst)
            .setAnchor(\.topAnchor, .equal, to: topAnchor, constant: UIConfig.barTopAnchorConst)
            .setAnchor(\.heightAnchor, .equal, constant: UIConfig.barHeight)
        
        addSubview(leftButton)
        leftButton
            .setAnchor(\.topAnchor, .equal, to: topAnchor)
            .setAnchor(\.leftAnchor, .equal, to: leftAnchor)
            .setAnchor(\.rightAnchor, .equal, to: centerXAnchor)
            .setAnchor(\.bottomAnchor, .equal, to: bottomAnchor)
        leftButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        
        addSubview(rightButton)
        rightButton
            .setAnchor(\.topAnchor, .equal, to: topAnchor)
            .setAnchor(\.leftAnchor, .equal, to: centerXAnchor)
            .setAnchor(\.rightAnchor, .equal, to: rightAnchor)
            .setAnchor(\.bottomAnchor, .equal, to: bottomAnchor)
        rightButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        
        addSubview(sentenceAndTranslationLabel)
        sentenceAndTranslationLabel
            .setAnchor(\.topAnchor, .equal, to: chineseLabel.bottomAnchor)
            .setAnchor(\.leftAnchor, .equal, to: leftAnchor, constant: UIConfig.anchorConst)
            .setAnchor(\.rightAnchor, .equal, to: rightAnchor, constant: -UIConfig.anchorConst)
            .setAnchor(\.bottomAnchor, .equal, to: loveButton.topAnchor)
                        
    }
    
    func binding() {
        loveWord.addObserver(self) { [weak self] word in
            self?.wordLabel.text = word.word
            self?.chineseLabel.text = word.chinese
        }
        
        index.addObserver(self) { [weak self] index in
            self?.barView.adjustBar(index: index)
            self?.switchCard(index: index)
        }
    }
}

extension LoveEnglishCardView {
    func update(word: LoveEnglishWord) {
        loveWord.just(word)
    }
}

extension LoveEnglishCardView {
    @objc
    func didTapLeftButton() {
        var indexValue = index.value
        indexValue = indexValue == 0 ? indexValue : indexValue - 1
        index.just(indexValue)
    }
    @objc
    func didTapRightButton() {
        var indexValue = index.value
        indexValue = indexValue == 2 ? indexValue: indexValue + 1
        index.just(indexValue)
    }
    
    private func switchCard(index: Int) {
        let page = LoveEnglishCardPage(rawValue: index)
        backgroundColor = page?.cardColor
    }
}

private extension LoveEnglishCardView {
    struct UIConfig {
        static let anchorConst: CGFloat = 10
        static let wordLabelHeight: CGFloat = 100
        static let cornerRadius: CGFloat = 10
        static let wordSize: CGFloat = 80
        static let chineseSize: CGFloat = 30
        static let sentenceAndTranslationSize: CGFloat = 30
        static let chineseLabelHeight: CGFloat = 60
        static let buttonSize: CGFloat = 50
        static let buttonBottomConst: CGFloat = 20
        static let barLeftRightConst: CGFloat = 10
        static let barTopAnchorConst: CGFloat = 5
        static let barHeight: CGFloat = 3
    }
}


enum LoveEnglishCardPage: Int {
    case firstPage = 0
    case secondPage
    case thridPage
    
    var cardColor: UIColor {
        switch self {
        case .firstPage: return .systemPink
        case .secondPage: return .init(red: 75/255, green: 172/255, blue: 123/255, alpha: 1)
        case .thridPage: return .init(red: 109/255, green: 158/255, blue: 195/255, alpha: 1)
        }
    }
}
