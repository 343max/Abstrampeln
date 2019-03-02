// Copyright Max von Webel. All Rights Reserved.

import UIKit
import CoreLocation

struct SearchResultItem {
  let label: String
  let detail: String?
  let coordinate: CLLocationCoordinate2D
}

protocol SearchResultsDataSource {
  func searchFor(text: String, completion: @escaping (_ text: String, _ results: [SearchResultItem]) -> ()) -> Bool
  func cancelSearchFor(text: String)
}

protocol SearchControllerDelegate: AnyObject {
  func didSelect(item: SearchResultItem)
}

class SearchController: NSObject {
  let sections: [Section]
  
  var searchText: String?
  weak var delegate: SearchControllerDelegate?
  
  var collectionView: UICollectionView? {
    didSet {
      if let collectionView = collectionView {
        collectionView.collectionViewLayout = Layout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SuggestionCell.self, forCellWithReuseIdentifier: SuggestionCell.identifier)
      }
    }
  }
  
  init(searchSources: [SearchResultsDataSource]) {
    self.sections = searchSources.map { Section(dataSource: $0) }
    super.init()
  }
  
  func searchFor(text: String) {
    guard searchText != text else { return }
    
    let oldSearchText = searchText
    searchText = text
    
    sections.enumerated().forEach { (index, section) in
      if let oldSearchText = oldSearchText, section.searching {
        section.dataSource.cancelSearchFor(text: oldSearchText)
      }
      
      section.searching = true
      let shouldWaitForResults = section.dataSource.searchFor(text: text, completion: { [weak self] (searchText, searchResults) in
        guard let self = self, searchText == text else { return }
        
        DispatchQueue.main.async {
          section.searching = false
          section.results = searchResults
          self.collectionView?.reloadSections(IndexSet(arrayLiteral: index))
        }
      })
      
      if !shouldWaitForResults {
        section.searching = false
        section.results = []
        self.collectionView?.reloadSections(IndexSet(arrayLiteral: index))
      }
    }
  }
}

extension SearchController {
  class Section {
    let dataSource: SearchResultsDataSource
    var searching = false
    var results: [SearchResultItem] = []
    
    init(dataSource: SearchResultsDataSource) {
      self.dataSource = dataSource
    }
  }
}

extension SearchController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return sections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sections[section].results.count
  }
  
  class SuggestionCell: UICollectionViewCell {
    static let identifier = "SuggestionCell"
    let stackView: UIStackView
    let label: UILabel
    let detailLabel: UILabel
    
    static func sizeFor(width: CGFloat) -> CGSize {
      return CGSize(width: width, height: 55)
    }
    
    override init(frame: CGRect) {
      label = UILabel(frame: .zero)
      label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
      label.numberOfLines = 0
      
      detailLabel = UILabel(frame: .zero)
      detailLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      detailLabel.numberOfLines = 0
      
      stackView = UIStackView(arrangedSubviews: [label, detailLabel])
      stackView.axis = .vertical
      stackView.spacing = 5
      
      super.init(frame: frame)
      
      self.backgroundView = UIView()
      
      addSubview(stackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    var item: SearchResultItem? {
      didSet {
        guard let item = item else { return }
        
        label.text = item.label
        detailLabel.text = item.detail
      }
    }
    
    override func prepareForReuse() {
      item = nil
      isSelected = false
    }
    
    override func layoutSubviews() {
      var frame = bounds.insetBy(dx: 10, dy: 7)
      frame.size = stackView.systemLayoutSizeFitting(frame.size)
      stackView.frame = frame
    }
    
    override var isSelected: Bool {
      didSet {
        backgroundView?.backgroundColor = isSelected ? UIColor(white: 0.3, alpha: 0.1) : .clear
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionCell.identifier, for: indexPath) as? SuggestionCell else {
      fatalError()
    }
    
    cell.item = sections[indexPath.section].results[indexPath.item]
    
    return cell
  }
}

extension SearchController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelect(item: sections[indexPath.section].results[indexPath.item])
  }
}

extension SearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return SuggestionCell.sizeFor(width: collectionView.bounds.width)
  }
}

extension SearchController {
  class Layout: UICollectionViewLayout {
    var cellSize: CGSize {
      get {
        return SuggestionCell.sizeFor(width: collectionView!.bounds.width)
      }
    }
    
    var itemCount: Int {
      get {
        return collectionView!.numberOfItems(inSection: 0)
      }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
      return true
    }
    
    override var collectionViewContentSize: CGSize {
      get {
        let cellSize = self.cellSize
        return CGSize(width: cellSize.width, height: cellSize.height * CGFloat(itemCount))
      }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      let cellSize = self.cellSize
      let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      
      attributes.frame = CGRect(origin: CGPoint(x: 0, y: cellSize.height * CGFloat(indexPath.item)), size: cellSize)
      
      return attributes
    }
    
    func layoutAttributesForItem(atIndex: Int) -> UICollectionViewLayoutAttributes? {
      return layoutAttributesForItem(at: IndexPath(item: atIndex, section: 0))
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
      guard itemCount > 0 else {
        return nil
      }
      
      func item(forY y: CGFloat, sideLength: CGFloat) -> Int {
        let unboundIndex = Int(floor(y / sideLength))
        return max(min(unboundIndex, itemCount - 1), 0)
      }
      
      let cellHeight = cellSize.height
      let range: ClosedRange<Int>
      range = item(forY: rect.minY, sideLength: cellHeight)...item(forY: rect.maxY, sideLength: cellHeight)
      
      return range.map({ (index) -> UICollectionViewLayoutAttributes in
        return layoutAttributesForItem(atIndex: index)!
      })
    }
  }
}
