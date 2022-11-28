//
//  LoveWord.swift
//  iLoveEnglish
//
//  Created by ethan on 2022/11/26.
//

import Foundation

class LoveEnglishWord {
    var word: String
    var chinese: String
    var sentence: String
    var translation: String
    init(word: String = "", chinese: String = "", sentence: String = "", translation: String = "") {
        self.word = word
        self.chinese = chinese
        self.sentence = sentence
        self.translation = translation
    }
}
