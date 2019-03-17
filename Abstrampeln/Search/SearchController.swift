// Copyright Max von Webel. All Rights Reserved.

import UIKit
import CoreLocation

protocol SearchResultsDataSource {
  func searchFor(text: String, completion: @escaping (_ text: String, _ results: [Location]) -> ()) -> Bool
  func cancelSearchFor(text: String)
}

class SearchController: NSObject {
  let sections: [Section]
  
  var searchText: String?
  
  var collectionView: UICollectionView? {
    didSet {
      if let collectionView = collectionView {
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
      var completionWasCalled = false
      let shouldWaitForResults = section.dataSource.searchFor(text: text, completion: { [weak self] (searchText, searchResults) in
        guard let self = self, searchText == text else { return }
        
        completionWasCalled = true
        
        DispatchQueue.main.async {
          section.searching = false
          section.results = searchResults
          self.collectionView?.reloadSections(IndexSet(arrayLiteral: index))
        }
      })
      
      if !shouldWaitForResults {
        section.searching = false
        if !completionWasCalled {
          section.results = []
          self.collectionView?.reloadSections(IndexSet(arrayLiteral: index))
        }
      }
    }
  }
}

extension SearchController {
  class Section {
    let dataSource: SearchResultsDataSource
    var searching = false
    var results: [Location] = []
    
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
    
    var item: Location? {
      didSet {
        guard let item = item else { return }
        
        label.text = item.label
        detailLabel.text = item.detail
        setNeedsLayout()
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
    let suggestion = sections[indexPath.section].results[indexPath.item]
    AppController.shared.directionsController.set(destination: suggestion, mode: .None)
  }
}

extension SearchController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return SuggestionCell.sizeFor(width: collectionView.bounds.width)
  }
}
