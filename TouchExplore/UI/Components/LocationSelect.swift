//
//  LocationSelect.swift
//  TouchExplore
//
//  Created by Dario Merz on 13.05.20.
//  Copyright © 2020 Dario Merz. All rights reserved.
//

import SwiftUI

struct LocationSelect: View {
    var body: some View {
		Section(header: Text("Demo-Locations")) {
			ScrollView(.horizontal, showsIndicators: false) {
				List {
					HStack {
						LocationSelectButton(action: {
							print("click")
						})
					}
				}
			}
		}
    }
}

struct LocationSelectButton: View {
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			VStack {
				Circle().size(width: 50, height: 50).padding(.bottom, 8)
				Text("Chinagarten, Zürich")
			}
		}
	}
}

struct LocationSelect_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelect()
    }
}
