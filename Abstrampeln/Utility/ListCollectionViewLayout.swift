// Copyright Max von Webel. All Rights Reserved.

import UIKit

class ListCollectionViewLayout: UICollectionViewLayout {
  var rowHeight: CGFloat = 0
  
  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }
  
  private func sectionItemCount() -> [Int] {
    let collectionView = self.collectionView!
    
    return (0..<collectionView.numberOfSections).map { (sectionIndex) -> Int in
      return collectionView.numberOfItems(inSection: sectionIndex)
    }
  }
  
  private func rowCount() -> Int {
    sectionItemCount().reduce(0) { (totalCount, sectionItemCount) -> Int in
      return totalCount + sectionItemCount
    }
  }
  
  override var collectionViewContentSize: CGSize {
    get {
      let collectionView = self.collectionView!
      return CGSize(
        width: collectionView.bounds.width,
        height: CGFloat(rowCount()) * rowHeight
      )
    }
  }
  
  private func sectionFrames() -> [CGRect] {
    var offset: CGFloat = 0
    let width = collectionView!.frame.width
    return sectionItemCount().map { (itemCount) -> CGRect in
      let frame = CGRect(x: 0,
                         y: offset,
                         width: width,
                         height: CGFloat(itemCount) * rowHeight)
      offset = frame.maxY
      return frame
    }
  }
  
  private func sections(in rect: CGRect) -> [Int: CGRect] {
    return sectionFrames().enumerated().reduce([Int: CGRect]()) { (constDict, element: (section: Int, frame: CGRect)) -> [Int: CGRect] in
      var dict = constDict
      dict[element.section] = element.frame
      return dict
    }.filter { (element: (section: Int, frame: CGRect)) -> Bool in
      rect.intersects(element.frame)
    }
  }
  
  private func items(in rect: CGRect) -> [IndexPath: CGRect] {
    let width = collectionView!.frame.width

    return sections(in: rect).flatMap { (section: (index: Int, frame: CGRect)) -> [(IndexPath, CGRect)] in
      let itemCount = Int(section.frame.height / rowHeight)
      return (0..<itemCount).map { (item) -> (IndexPath, CGRect) in
        return (
          IndexPath(item: item, section: section.index),
          CGRect(
            x: 0,
            y: section.frame.minY + rowHeight * CGFloat(item),
            width: width,
            height: rowHeight
          )
        )
      }
    }.reduce([IndexPath: CGRect]()) { (constDict, item: (indexPath: IndexPath, frame: CGRect)) -> [IndexPath: CGRect] in
      var dict = constDict
      dict[item.indexPath] = item.frame
      return dict
    }
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    items(in: rect).map { (element: (indexPath: IndexPath, frame: CGRect)) -> UICollectionViewLayoutAttributes in
      let attributes = UICollectionViewLayoutAttributes(forCellWith: element.indexPath)
      attributes.frame = element.frame
      return attributes
    }
  }
}
