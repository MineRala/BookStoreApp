import XCTest
@testable import BookStoreApp

class TableViewCellTests: XCTestCase {

    var tableViewCell: TableViewCell!
    var mockViewModel: MockTableViewCellViewModel!
    var mockCacheManager: MockCacheManager!

    override func setUp() {
        super.setUp()

        let bundle = Bundle(for: TableViewCell.self)
        let nib = UINib(nibName: "TableViewCell", bundle: bundle)
        tableViewCell = nib.instantiate(withOwner: nil, options: nil).first as? TableViewCell

        mockCacheManager = MockCacheManager()
        mockCacheManager.imageToReturn = UIImage(named: "image")

        mockViewModel = MockTableViewCellViewModel()

        tableViewCell.configureCell(with: mockViewModel)
    }

    override func tearDown() {
        tableViewCell = nil
        mockViewModel = nil
        mockCacheManager = nil
        super.tearDown()
    }

    func testUpdateUIWithBook() {
        // Given
        let book = BookModel(
            artistName: "Anonymous",
            name: "Severance",
            date: "2022-03-18",
            imageUrl: "https://is1-ssl.mzstatic.com/image/thumb/Publication126/v4/0c/cf/d5/0ccfd594-6286-9daf-df93-3239b2f07e1c/SEV1_BookCover.jpg/100x134bb.png"
        )

        // When
        tableViewCell.updateUI(with: book, cacheManager: mockCacheManager)

        // Then
        XCTAssertEqual(tableViewCell.titleLabel.text, "Severance", "Title label should display the correct book name")
        XCTAssertEqual(tableViewCell.authorLabel.text, "Anonymous", "Author label should display the correct author name")
        XCTAssertEqual(tableViewCell.dateLabel.text, "18.03.2022", "Date label should display the correct date format")
        XCTAssertNotNil(tableViewCell.posterImageView.image, "Poster image should not be nil")
    }

    func testViewModelViewDidLoadCalled() {
        // Given:
        // When:
        tableViewCell.configureCell(with: mockViewModel)

        // Then:
        XCTAssertTrue(mockViewModel.viewDidLoadCalled, "viewDidLoad should be called in the view model when the cell is configured")
    }
}
