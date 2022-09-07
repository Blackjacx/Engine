//
//  UIView+Extensions.swift
//  Quickie
//
//  Created by Stefan Herold on 21.02.20.
//  Copyright © 2020 Stefan Herold. All rights reserved.
//

#if canImport(UIKit)
import UIKit

#if !os(watchOS)
public extension UIView {

    // MARK: - Autolayout

    /// Adds the view to a parent view and sets the Auto Layout constraints so
    /// the view is maximized on the parent respecting the given margin and
    /// layout-constraint priority.
    /// - Parameters:
    ///   - parent: The parent to add the view to.
    ///   - insets: The top, leading, bottom and trailing insets of the sub its parent view.
    ///   - priority: The priority all constraints should be given to avoid
    ///   constraint warnings in the console when e.g. the view is inside a
    ///   stack view and is hidden during the app lifecycle.
    func addMaximizedTo(_ parent: UIView,
                        insets: NSDirectionalEdgeInsets = .zero,
                        priority: UILayoutPriority? = nil) {

        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)

        let constraints = [
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.leading),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -insets.trailing),
            topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom)
        ]

        if let priority = priority {
            constraints.forEach { $0.priority = priority }
        }

        // Activate all constraints
        NSLayoutConstraint.activate(constraints)
    }

    /// Adds the view to a parent view.
    /// - parameter parent: The parent to add the view to.
    func addTo(_ parent: UIView) {

        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)
    }

    /// Adds the view to a parent view pinned to the sides and verticall centered.
    /// - parameter parent: The parent to add the view to.
    func addVerticallyCenteredTo(_ parent: UIView, insets: NSDirectionalEdgeInsets = .zero) {

        translatesAutoresizingMaskIntoConstraints = false
        parent.addSubview(self)

        let constraints: [NSLayoutConstraint] = [
            centerYAnchor.constraint(equalTo: parent.centerYAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: insets.leading),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -insets.trailing)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setWidth(_ value: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {

        constraints.first { $0.firstAnchor == widthAnchor }?.isActive = false
        let constraint = widthAnchor.constraint(equalToConstant: value)
        if let priority = priority {
            constraint.priority = priority
        }
        return constraint
    }

    func setHeight(_ value: CGFloat, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {

        constraints.first { $0.firstAnchor == heightAnchor }?.isActive = false
        let constraint = heightAnchor.constraint(equalToConstant: value)
        if let priority = priority {
            constraint.priority = priority
        }
        return constraint
    }

    // MARK: - Layer Manipulation

    func applyShadow() {

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.25
    }

    func removeShadow() {

        layer.shadowColor = nil
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
    }

    func applyContourLine(color: UIColor) {

        layer.borderWidth = 1 / UIScreen.main.scale
        layer.borderColor = color.cgColor
    }

    func applyParallax() {

        let amount = 10

        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        addMotionEffect(group)
    }

    // MARK: - Stack Views

    func showArrangedSubview(_ show: Bool = true) {

        // Addresses an UIStackView bug when hiding an already hidden arranged subview
        if show {
            if isHidden {
                isHidden = false
                alpha = 1.0
            }
        } else {
            if !isHidden {
                isHidden = true
                alpha = 0.0
            }
        }
    }

    // MARK: - Animations

    func jump() {
        let up = CGAffineTransform().translatedBy(x: 0, y: -25)
        let down = CGAffineTransform().translatedBy(x: 0, y: 25)

        // Start with up
        self.transform = up

        let options: UIView.AnimationOptions = [
            .allowUserInteraction,
            .autoreverse,
            .curveEaseIn
        ]
        let animations: () -> Void = {
            UIView.modifyAnimations(withRepeatCount: 5, autoreverses: true) {
                self.transform = down
            }
        }
        let completion: (Bool) -> Void = { (isFinished) in
            self.transform = .identity
        }
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: options,
                       animations: animations,
                       completion: completion)
    }
}
#endif
#endif
