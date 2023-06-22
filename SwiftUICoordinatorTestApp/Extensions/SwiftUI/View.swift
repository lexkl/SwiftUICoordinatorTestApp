//
//  View.swift
//  SwiftUICoordinatorTestApp
//
//  Created by Aleksey Klyonov on 21.06.2023.
//

import Foundation
import SwiftUI

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
