//
//  LevelsIndicatorView.swift
//  LevelUp
//
//  Created by 1 on 15.12.2021.
//

import UIKit

class LevelsIndicatorView: UIView {
    
    var levels: Int {
        didSet {
            self.subviews.forEach { $0.removeFromSuperview() }
            imageViews.removeAll()
            commInit()
        }
    }
    
    var levelsDone = 0 {
        didSet {
            print(levelsDone)
            let index = levelsDone - 1
            let imageView = imageViews[index]
            if #available(iOS 13.0, *) {
                imageView.image = UIImage(systemName: "checkmark.circle.fill")
            } else {
                // Fallback on earlier versions
            }
            imageView.tintColor = .systemGreen
            let animation = { imageView.transform = .init(scaleX: 1.4, y: 1.4) }
//            let complition = { _ in imageView.transform = .identity }
            UIView.animate(withDuration: 0.25, delay: 0, options: [], animations: animation) {_ in
                imageView.transform = .identity
            }
        }
    }
    
    var imageViews: [UIImageView] = []
    
    init(levels: Int) {
        self.levels = levels
        super.init(frame: .zero)
        
        commInit()
    }
    
    func commInit() {
        self.clipsToBounds = false
        self.backgroundColor = .black
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        for _ in 1...levels {
            let image: UIImage
            if #available(iOS 13.0, *) {
                image = UIImage(systemName: "circle")!
            } else {
                image = UIImage()
                // Fallback on earlier versions
            }
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .white
            imageView.makeSqr()
            imageViews.append(imageView)
            stack.addArrangedSubview(imageView)
        }
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stack)
        stack.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        self.levels = 3
        super.init(coder: coder)

        commInit()
    }
}

extension UIView {
    func fillSuperView() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
    }
    
    func ancherToSuperviewsCenter() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
    
    func makeSqr() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: self.heightAnchor),
        ])
    }
}
