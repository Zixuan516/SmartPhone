//  KHabit
//
//  Created by Zixuan Xiao on 19/11/2020.
//  Copyright © 2020 My company
//

import SwiftUI




struct NavigationLazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
