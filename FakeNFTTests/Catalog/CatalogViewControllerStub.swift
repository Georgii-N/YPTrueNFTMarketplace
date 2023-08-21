//
//  CatalogViewControllerStub.swift
//  FakeNFTTests
//
//  Created by Евгений on 21.08.2023.
//

@testable import FakeNFT
import UIKit

final class CatalogViewControllerStub: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(CatalogTableViewCell.self)
        tableView.dataSource = self
    }
}

extension CatalogViewControllerStub: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CatalogTableViewCell = tableView.dequeueReusableCell()
        
        cell.setupCollectionModel(model: NFTCollection(createdAt: "", name: "TestCell", cover: "", nfts: [],
                                                       description: "", author: "", id: ""))
        
        return cell
    }
}
