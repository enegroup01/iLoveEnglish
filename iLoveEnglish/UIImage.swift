//
//  UIImage.swift
//  iLoveEnglish
//
//  Created by ethan on 2022/11/29.
//
import UIKit

public extension UIImage {
    func applyImageColor(tintColor: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        draw(in: drawRect)
        tintColor.set()
        UIRectFillUsingBlendMode(drawRect, .sourceAtop)
        guard let tintedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return tintedImage
    }
}
