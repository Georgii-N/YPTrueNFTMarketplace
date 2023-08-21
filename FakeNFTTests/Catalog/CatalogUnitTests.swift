@testable import FakeNFT
import XCTest

final class CatalogUnitTests: XCTestCase {
    
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
        let expectietion = expectation(description: "fetch NFTCollection test")
        
        // When:
        expectietion.expectedFulfillmentCount = 1
        catalogVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: expectietion.fulfill)
        
        // Then:
        wait(for: [expectietion], timeout: 0.5)
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
        wait(for: [expectietion], timeout: 0.5)
        XCTAssertNotNil(catalogVM.$networkError)
    }
    
    func testCatalogCollectionsDidFilled() {
        // Then:
        let dataProvider = DataProviderStub()
        let catalogVM = CatalogViewModelStub(provider: dataProvider)
        let catalogVC = CatalogViewController(viewModel: catalogVM)
        let expectietion = expectation(description: "fill collections")
        
        // When:
        expectietion.expectedFulfillmentCount = 1
        catalogVC.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: expectietion.fulfill)
        
        // Then:
        wait(for: [expectietion], timeout: 0.5)
        XCTAssertNotNil(catalogVM.nftCollections)
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
        wait(for: [expectietion], timeout: 0.5)
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
        wait(for: [expectietion], timeout: 0.5)
        XCTAssertGreaterThan(sortedCollectionQuantity, baseCollectionQuantity)
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
}
