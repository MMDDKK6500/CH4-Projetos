//
//  ViewExtension.swift
//  Zip
//
//  Created by João Duque Nardelli Wandermuren on 27/08/26.
//

import Foundation
import SwiftUI

public extension View {
  /// Modify a view with a `ViewBuilder` closure.
  ///
  /// This represents a streamlining of the
  /// [`modifier`](https://developer.apple.com/documentation/swiftui/view/modifier(_:))
  /// \+ [`ViewModifier`](https://developer.apple.com/documentation/swiftui/viewmodifier)
  /// pattern.
  /// - Note: Useful only when you don't need to reuse the closure.
  /// If you do, turn the closure into an extension! ♻️
  func modifier<ModifiedContent: View>(
    @ViewBuilder body: (_ content: Self) -> ModifiedContent
  ) -> ModifiedContent {
    body(self)
  }
}
