//
//  StringLocalization.swift
//  Navigation
//
//  Created by Дмитрий Ильинский on 05.03.2026.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
