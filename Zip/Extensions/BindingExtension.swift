//
//  BindingExtension.swift
//  Projetos
//
//  Created by João Duque Nardelli Wandermuren on 21/08/26.
//

import Foundation
import SwiftUI

extension Binding where Value: Equatable {
    func equals(_ other: Value, else unset: Value) -> Binding<Bool> {
        Binding<Bool>(
            get: { self.wrappedValue == other },
            set: { self.wrappedValue = $0 ? other : unset }
        )
    }
}
