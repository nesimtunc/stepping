//
//  Modifiers.swift
//  Stepping
//
//  Created by Neso on 2020/10/06.
//

import SwiftUI

struct BigText: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(Font.system(size: 50, design: .rounded))
			.frame(minWidth: 0, maxWidth: .infinity, minHeight:100, maxHeight: 100)
			.layoutPriority(1)
	}
}
