//
//  DataProviderStub.swift
//  FakeNFTTests
//
//  Created by Евгений on 21.08.2023.
//

@testable import FakeNFT

final class DataProviderStub: DataProviderProtocol {
    
    var isError = false
    
    func fetchNFTCollection(completion: @escaping (Result<FakeNFT.NFTCollections, Error>) -> Void) {
        if !isError {
            let firstCollection = NFTCollection(createdAt: "",
                                                name: "BCollection",
                                                cover: "",
                                                nfts: [""],
                                                description: "",
                                                author: "",
                                                id: "")
            let secondCollection = NFTCollection(createdAt: "",
                                                 name: "ACollection",
                                                 cover: "",
                                                 nfts: ["", ""],
                                                 description: "",
                                                 author: "",
                                                 id: "")
            completion(.success([firstCollection, secondCollection]))
        } else {
            completion(.failure(NetworkClientError.httpStatusCode(404)))
        }
    }
    
    func fetchUsersRating(completion: @escaping (Result<FakeNFT.UsersResponse, Error>) -> Void) {
        
    }
    
    func fetchUserID(userId: String, completion: @escaping (Result<FakeNFT.UserResponse, Error>) -> Void) {
        
    }
    
    func fetchProfile(completion: @escaping (Result<FakeNFT.Profile, Error>) -> Void) {
        
    }
    
    func fetchUsersNFT(userId: String?, nftsId: [String]?, completion: @escaping (Result<FakeNFT.NFTCards, Error>) -> Void) {
        if !isError {
            let NFTCard = NFTCard(createdAt: "",
                                  name: "TestNFTCard",
                                  images: [],
                                  rating: 5,
                                  description: "",
                                  price: 5,
                                  author: "",
                                  id: "")
            completion(.success([NFTCard]))
        } else {
            completion(.failure(NetworkClientError.httpStatusCode(404)))
        }
    }
    
    func fetchCurrencies(completion: @escaping (Result<FakeNFT.Currencies, Error>) -> Void) {
        
    }
    
    func fetchOrder(completion: @escaping (Result<FakeNFT.Order, Error>) -> Void) {
        
    }
    
    func putNewProfile(profile: FakeNFT.Profile, completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
    
    func putNewOrder(order: FakeNFT.Order, completion: @escaping (Result<FakeNFT.Order, Error>) -> Void) {
        
    }
    
    func fetchPaymentCurrency(currencyId: Int, completion: @escaping (Result<FakeNFT.OrderPayment, Error>) -> Void) {
        
    }
}
