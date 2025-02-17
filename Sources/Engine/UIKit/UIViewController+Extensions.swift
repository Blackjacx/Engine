//
//  UIViewController+Extensions.swift
//  Engine
//
//  Created by Stefan Herold on 07.09.22.
//

#if canImport(UIKit)
import UIKit

#if !os(watchOS)
public extension UIViewController {

    func setControlsEnabledState(_ isEnabled: Bool) {

        #if !os(tvOS)
        navigationItem.setHidesBackButton(!isEnabled, animated: true)
        #endif

        navigationItem.leftBarButtonItems?.forEach {
            $0.isEnabled = isEnabled
        }
        navigationItem.leftBarButtonItem?.isEnabled = isEnabled

        navigationItem.rightBarButtonItems?.forEach {
            $0.isEnabled = isEnabled
        }
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled

        #if !os(tvOS)
        toolbarItems?.forEach {
            $0.isEnabled = isEnabled
        }
        #endif
    }
}
#endif
#endif
