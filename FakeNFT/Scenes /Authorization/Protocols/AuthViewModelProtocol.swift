//
//  AuthViewModelProtocol.swift
//  FakeNFT
//
//  Created by Евгений on 09.08.2023.
//

import Foundation

protocol AuthViewModelProtocol: AnyObject {
    var loginPasswordMistakeObservable: Observable<Bool?> { get }
    var isAuthorizationDidSuccesfulObserver: Observable<Bool?> { get }
    func setNewLoginPassword(login: String, password: String)
    func authorize()
}
