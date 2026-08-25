//
//  ZipNavigation.swift
//  Projetos
//
//  Created by Maria Clara Fernandes Bessa on 20/08/26.
//

import SwiftUI

struct ZipNavigation {
    @ViewBuilder static func viewShowed(rote: ZipNavigationEnum) -> some View {
        switch rote {
        //     case .splash:
        //         TelaSplash(aoTerminar: {})

        case .welcomeView:
            WelcomeView()

        case .onBoarding:
            SheetOnBoarding()

        case .homeView:
            HomeView()

        }
    }
}
