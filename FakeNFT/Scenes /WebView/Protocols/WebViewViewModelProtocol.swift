//
//  WebViewViewModelProtocol.swift
//  FakeNFT
//
//  Created by Евгений on 02.08.2023.
//

import Foundation

protocol WebViewViewModelProtocol: AnyObject {
    var currentProgressObserver: Observable<Float> { get }
    var isReadyToHideProgressViewObservable: Observable<Bool> { get }
    func setupProgres(newValue: Double)
}
