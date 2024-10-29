//
//  MemoItem.swift
//  IncrementMemo
//
//  Created by Kei on 2024/10/30.
//

import SwiftData
import Foundation

@Model
class MemoItem {
  @Attribute(.unique) public let id = UUID()
  var title: String
  var content: String

  init(title: String, content: String) {
    self.title = title
    self.content = content
  }
}
