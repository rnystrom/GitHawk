//
//  IssueCommentBaseCell.swift
//  Freetime
//
//  Created by Ryan Nystrom on 12/30/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit

protocol IssueCommentGestureDelegate: class {
    func didDoubleTap(cell: IssueCommentBaseCell)
    func didLongPress(cell: IssueCommentBaseCell)
}

class IssueCommentBaseCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    static let collapseCellMinHeight: CGFloat = 45

    weak var gestureDelegate: IssueCommentGestureDelegate?
    let doubleTapGesture = UITapGestureRecognizer()
    let longPressGesture = UILongPressGestureRecognizer()

    private let collapseLayer = CAGradientLayer()
    private let collapseButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.clipsToBounds = true

        doubleTapGesture.addTarget(self, action: #selector(onDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.delegate = self
        addGestureRecognizer(doubleTapGesture)

        setupLongPressGesture()
        collapseLayer.isHidden = true
        collapseLayer.colors = [
            UIColor(white: 1, alpha: 0).cgColor,
            UIColor(white: 1, alpha: 1).cgColor,
            UIColor(white: 1, alpha: 1).cgColor
        ]
        collapseLayer.locations = [0, 0.5, 1]

        collapseButton.setImage(UIImage(named: "bullets")?.withRenderingMode(.alwaysTemplate), for: .normal)
        collapseButton.backgroundColor = Styles.Colors.Blue.medium.color
        collapseButton.accessibilityTraits = UIAccessibilityTraitNone
        collapseButton.tintColor = .white
        collapseButton.titleLabel?.font = Styles.Text.smallTitle.preferredFont
        collapseButton.isHidden = true
        collapseButton.contentEdgeInsets = UIEdgeInsets(top: -2, left: 8, bottom: -2, right: 8)
        collapseButton.imageEdgeInsets = .zero
        collapseButton.sizeToFit()
        collapseButton.layer.cornerRadius = collapseButton.bounds.height / 2
        collapseButton.layer.borderColor = UIColor(white: 1, alpha: 0.2).cgColor
        collapseButton.layer.borderWidth = 1
        collapseButton.isUserInteractionEnabled = false // allow tap to pass through to cell
        contentView.addSubview(collapseButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutContentViewForSafeAreaInsets()

        let contentBounds = contentView.bounds

        if collapseLayer.isHidden == false {
            contentView.layer.addSublayer(collapseLayer)
            contentView.bringSubview(toFront: collapseButton)

            let collapseFrame = CGRect(
                x: contentBounds.minX,
                y: contentBounds.height - IssueCommentBaseCell.collapseCellMinHeight,
                width: contentBounds.width,
                height: IssueCommentBaseCell.collapseCellMinHeight
            )

            // disable implicit CALayer animations
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            collapseLayer.frame = collapseFrame
            CATransaction.commit()

            collapseButton.center = CGPoint(
                x: collapseFrame.width / 2,
                y: collapseFrame.maxY - collapseButton.bounds.height / 2
            )
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collapseLayer.isHidden = true
        collapseButton.isHidden = true
    }
  
    private func setupLongPressGesture()
    {
      longPressGesture.addTarget(self, action: #selector(onLongPress))
      longPressGesture.minimumPressDuration = 0.5
      longPressGesture.delegate = self
      addGestureRecognizer(longPressGesture)
    }

    // MARK: Private API

    @objc private func onDoubleTap() {
        gestureDelegate?.didDoubleTap(cell: self)
    }
  
    @objc private func onLongPress() {
      if(longPressGesture.state == .began) {
        gestureDelegate?.didLongPress(cell: self)
      }
    }

    var collapsed: Bool = false {
        didSet {
            collapseButton.isHidden = !collapsed
            collapseLayer.isHidden = !collapsed
            setNeedsLayout()
        }
    }

    // MARK: UIGestureRecognizerDelegate

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
        return true
    }

}
