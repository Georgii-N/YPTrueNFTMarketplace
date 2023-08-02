//
//  WebViewViewModel.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import UIKit

final class WebViewViewModel: WebViewViewModelProtocol {
    
    var currentProgressObserver: Observable<Float> {
        $currentProgress
    }
    
    @Observable
    private(set) var currentProgress: Float = 0.0
    
    func setupProgres(newValue: Double) {
        currentProgress = Float(newValue)
    }
}
