import Foundation
import SwiftUI
import UIKit

struct Blurview : UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<Blurview>) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Blurview>) {
    }
}
/*
//
//  BlurView.swift
//  TactileMaps
//
//  Created by Dario Merz on 03.05.20.
//  Copyright © 2020 Dario Merz. All rights reserved.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
	
    let style: UIBlurEffect.Style

    func makeUIView(context: UIViewRepresentableContext<BlurView>) -> UIView {
        let view = UIView(frame: .zero)
		view.backgroundColor = .clear
        
		let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        
		blurView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(blurView, at: 0)
        
		NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
		return view
    }

    func updateUIView(_ uiView: UIView,
                      context: UIViewRepresentableContext<BlurView>) {

    }
}
*/
