@testable import FakeNFT
import XCTest

final class CatalogUnitTests: XCTestCase {
    
    let nftCollection = NFTCollection(createdAt: "",
                                      name: "TestCollection",
                                      cover: "", nfts: [],
                                      description: "",
                                      author: "",
                                      id: "")
    
    func testCatalogSettingDataProvider() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogVM = CatalogViewModelStub(provider: dataProvider)
        let catalogVC = CatalogViewController(viewModel: catalogVM)

        // When:
        catalogVC.viewDidLoad()
        
        // Then:
        XCTAssertNotNil(catalogVM.provider)
    }
    
    func testCatalogBlockUI() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogVM = CatalogViewModelStub(provider: dataProvider)
        let catalogVC = CatalogViewController(viewModel: catalogVM)

        // When:
        catalogVC.viewDidLoad()
        
        // Then:
        XCTAssertFalse(catalogVC.view.isUserInteractionEnabled)
    }
    
    func testCatalogUnblockUI() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogVM = CatalogViewModelStub(provider: dataProvider)
        let catalogVC = CatalogViewController(viewModel: catalogVM)
        let expectietion = expectation(description: "test catalog unblockUI")
        
        // When:
        expectietion.expectedFulfillmentCount = 1
        catalogVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: expectietion.fulfill)
        
        // Then:
        wait(for: [expectietion], timeout: 1)
        XCTAssertTrue(catalogVC.view.isUserInteractionEnabled)
    }
    
    func testCatalogThrowsError() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogVM = CatalogViewModelStub(provider: dataProvider)
        let catalogVC = CatalogViewController(viewModel: catalogVM)
        let expectietion = expectation(description: "fetch NFTCollection error test")
        
        // When:
        dataProvider.isError = true
        expectietion.expectedFulfillmentCount = 1
        catalogVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: expectietion.fulfill)
        
        // Then:
        wait(for: [expectietion], timeout: 1)
        XCTAssertNotNil(catalogVM.$networkError)
    }
    
    func testCatalogSortByTitle() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogVM = CatalogViewModelStub(provider: dataProvider)
        let catalogVC = CatalogViewController(viewModel: catalogVM)
        let expectietion = expectation(description: "sort By title")
        
        // When:
        expectietion.expectedFulfillmentCount = 1
        catalogVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: expectietion.fulfill)
        let baseCollectionTitle = catalogVM.nftCollections?.first?.name ?? ""
        catalogVM.sortNFTCollection(option: .byTitle)
        let sortedCollectionTitle = catalogVM.nftCollections?.first?.name ?? ""
        
        // Then:
        wait(for: [expectietion], timeout: 1)
        XCTAssertGreaterThan(baseCollectionTitle, sortedCollectionTitle)
    }
    
    func testCatalogSortByQuantity() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogVM = CatalogViewModelStub(provider: dataProvider)
        let catalogVC = CatalogViewController(viewModel: catalogVM)
        let expectietion = expectation(description: "sort By quantity")
        
        // When:
        expectietion.expectedFulfillmentCount = 1
        catalogVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: expectietion.fulfill)
        let baseCollectionQuantity = catalogVM.nftCollections?.first?.nfts.count ?? 0
        catalogVM.sortNFTCollection(option: .byQuantity)
        let sortedCollectionQuantity = catalogVM.nftCollections?.first?.nfts.count ?? 0
        
        // Then:
        wait(for: [expectietion], timeout: 1)
        XCTAssertGreaterThan(sortedCollectionQuantity, baseCollectionQuantity)
    }
    
    func testCatalogViewModelFetchCollection() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogVM = CatalogViewModel(dataProvider: dataProvider)
        let catalogVC = CatalogViewController(viewModel: catalogVM)
        let expectation = expectation(description: "fetch catalog collection")
        
        // When:
        catalogVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: expectation.fulfill)
        
        // Then:
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(catalogVM.nftCollections)
    }
    
    func testCatalogSetupTableViewCell() {
        // Given:
        let catalogVC = CatalogViewControllerStub()
        
        // When:
        catalogVC.viewDidLoad()
        guard let cell = catalogVC.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CatalogTableViewCell else { return }
        
        // Then:
        XCTAssertNotNil(cell)
    }
    
    func testCatalogGetTableViewCell() {
        // Given:
        let catalogVC = CatalogViewControllerStub()
        
        // When:
        catalogVC.viewDidLoad()
        guard let cell = catalogVC.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CatalogTableViewCell else { return }
        let model = cell.getCollectionModel()
        
        // Then:
        XCTAssertEqual(model.name, "TestCell")
    }
    
    func testCatalogCollectionSettingDataProvider() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogCollectionVM = CatalogCollectionViewModel(dataProvider: dataProvider, collection: nftCollection)
        let catalogCollectionVC = CatalogCollectionViewController(viewModel: catalogCollectionVM)
        
        // When:
        catalogCollectionVC.viewDidLoad()
        
        // Then:
        XCTAssertNotNil(catalogCollectionVM.provider)
    }
    
    func testCatalogCollectionBlockUI() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogCollectionVM = CatalogCollectionViewModel(dataProvider: dataProvider, collection: nftCollection)
        let catalogCollectionVC = CatalogCollectionViewController(viewModel: catalogCollectionVM)
        
        // When:
        catalogCollectionVC.viewDidLoad()
        
        // Then:
        XCTAssertFalse(catalogCollectionVC.view.isUserInteractionEnabled)
    }
    
    func testCatalogCollectionUnblockUI() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogCollectionVM = CatalogCollectionViewModelStub(dataProvider: dataProvider, collection: nftCollection)
        let catalogCollectionVC = CatalogCollectionViewController(viewModel: catalogCollectionVM)
        let expectation = expectation(description: "fetch NFT cards test")
        
        // When:
        catalogCollectionVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: expectation.fulfill)
        
        // Then:
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(catalogCollectionVC.view.isUserInteractionEnabled)
    }
    
    func testCatalogCollectionThrowsError() {
        // Given:
        let dataProvider = DataProviderStub()
        let catalogCollectionVM = CatalogCollectionViewModelStub(dataProvider: dataProvider, collection: nftCollection)
        let catalogCollectionVC = CatalogCollectionViewController(viewModel: catalogCollectionVM)
        let expectation = expectation(description: "fetch NFT cards test")
        
        // When:
        dataProvider.isError = true
        catalogCollectionVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: expectation.fulfill)
        
        // Then:
        wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(catalogCollectionVM.networkError)
    }
    
    func testCatalogCollectionFetchProfile() {
        
    }
    
    func testCatalogCollectionFetchOrder() {
        
    }
    
    func testCatalogCollectionFetchAuthor() {
        
    }
    
    func testCatalogCollectionFetchNFTS() {
        
    }
}
