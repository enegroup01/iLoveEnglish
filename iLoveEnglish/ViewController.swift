//
//  ViewController.swift
//  iLoveEnglish
//
//  Created by ethan on 2022/11/26.
//

import UIKit

class ViewController: UIViewController {
    
    
    var cardView: LoveEnglishCardView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let cardView = LoveEnglishCardView()
        view.addSubview(cardView)
        cardView
            .setAnchor(\.topAnchor, .equal, to: view.topAnchor, constant: UIConfig.cardYAxis)
            .setAnchor(\.leftAnchor, .equal, to: view.leftAnchor, constant: UIConfig.cardXAxis)
            .setAnchor(\.rightAnchor, .equal, to: view.rightAnchor, constant: -UIConfig.cardXAxis)
            .setAnchor(\.bottomAnchor, .equal, to: view.bottomAnchor, constant: -UIConfig.cardYAxis)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        cardView.isUserInteractionEnabled = true
        cardView.addGestureRecognizer(gesture)
        cardView.update(word: LoveEnglishWord(word: "test", chinese: "n. 試驗；測驗", sentence: "A simple test will show if this is real gold.", translation: "簡單的試驗就能證明這是否是真金。"))
    }
    
    @objc
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: view)
        let label = gestureRecognizer.view!
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2)
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(abs(100 / xFromCenter), 1)
        var stretchAndRotation = rotation.scaledBy(x: scale, y: scale) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
        label.transform = stretchAndRotation
        
        if gestureRecognizer.state == .ended {
            var acceptedOrRejected = ""
            if label.center.x < 100 {
                acceptedOrRejected = "rejected"
                print("*= rejected")
            } else if label.center.x > self.view.bounds.width - 100 {
                acceptedOrRejected = "accepted"
                print("*= accepted")
            }
            
//            if acceptedOrRejected != "" && displayedUserID != "" {
//                PFUser.current()?.addUniqueObjects(from: [displayedUserID], forKey: acceptedOrRejected)
//                PFUser.current()?.saveInBackground(block: { (success, error) in
//                    print(PFUser.current())
//                    self.updateImage()
//                })
//            }
            print("*= ended")
            
            rotation = CGAffineTransform(rotationAngle: 0)
            stretchAndRotation = rotation.scaledBy(x: 1, y: 1) // rotation.scaleBy(x: scale, y: scale) is now rotation.scaledBy(x: scale, y: scale)
            label.transform = stretchAndRotation
            label.center = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
        }
    }
}

private extension ViewController {
    struct UIConfig {
        static let cardXAxis: CGFloat = 50
        static let cardYAxis: CGFloat = 250
    }
}

extension UIView {
    func preventMultipleClick(delay: TimeInterval = 1) {
        self.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false, block: { [weak self] _ in
            self?.isUserInteractionEnabled = true
        })
    }

    func changeHeight(height: CGFloat) {
        self.frame = CGRect(x: 0, y: height, width: self.frame.width, height: self.frame.height)
    }
}

public extension UIView {
    @discardableResult
    func setConstraint<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (
        _ keyPath: KeyPath<UIView, LayoutType>,
        _ relation: NSLayoutConstraint.Relation,
        to anchor: LayoutType,
        constant: CGFloat = 0,
        mutiplier: CGFloat? = nil,
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        if let mutiplier = mutiplier,
            let dimension = self[keyPath: keyPath] as? NSLayoutDimension,
            let anchor = anchor as? NSLayoutDimension {
            switch relation {
            case .equal:
                constraint = dimension.constraint(equalTo: anchor, multiplier: mutiplier, constant: constant)
            case .greaterThanOrEqual:
                constraint = dimension.constraint(greaterThanOrEqualTo: anchor, multiplier: mutiplier, constant: constant)
            case .lessThanOrEqual:
                constraint = dimension.constraint(lessThanOrEqualTo: anchor, multiplier: mutiplier, constant: constant)
            default:
                constraint = NSLayoutConstraint()
            }
        } else {
            switch relation {
            case .equal:
                constraint = self[keyPath: keyPath].constraint(equalTo: anchor, constant: constant)
            case .greaterThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(greaterThanOrEqualTo: anchor, constant: constant)
            case .lessThanOrEqual:
                constraint = self[keyPath: keyPath].constraint(lessThanOrEqualTo: anchor, constant: constant)
            default:
                constraint = NSLayoutConstraint()
            }
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setConstraint(
        _ keyPath: KeyPath<UIView, NSLayoutDimension>,
        _ relation: NSLayoutConstraint.Relation,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
        ) -> NSLayoutConstraint {
        let constraint: NSLayoutConstraint
        let dimension: NSLayoutDimension = self[keyPath: keyPath]
        switch relation {
        case .equal:
            constraint = dimension.constraint(equalToConstant: constant)
        case .greaterThanOrEqual:
            constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThanOrEqual:
            constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
        default:
            constraint = NSLayoutConstraint()
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    @discardableResult
    func setAnchor(
        _ keyPath: KeyPath<UIView, NSLayoutDimension>,
        _ relation: NSLayoutConstraint.Relation,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
        ) -> UIView {
        setConstraint(keyPath, relation, constant: constant, priority: priority)
        return self
    }

    @discardableResult
    func setAnchor<LayoutType: NSLayoutAnchor<AnchorType>, AnchorType> (
        _ keyPath: KeyPath<UIView, LayoutType>,
        _ relation: NSLayoutConstraint.Relation,
        to anchor: LayoutType,
        constant: CGFloat = 0,
        mutiplier: CGFloat? = nil,
        priority: UILayoutPriority = .required
        ) -> UIView {
        setConstraint(keyPath, relation, to: anchor, constant: constant, mutiplier: mutiplier, priority: priority)
        return self
    }

    func addConstraintWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

