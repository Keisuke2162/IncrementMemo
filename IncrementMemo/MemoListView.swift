//
//  MemoListView.swift
//  IncrementMemo
//
//  Created by Kei on 2024/10/30.
//

import SwiftData
import SwiftUI

struct MemoListView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var memos: [MemoItem]

  var body: some View {
      NavigationStack {
        List {
          ForEach(memos, id: \.id) { memo in
            NavigationLink(destination: MemoDetailView(memo: memo)) {
              Text(memo.title)
            }
          }
          .onDelete(perform: deleteMemo)
        }
        .navigationTitle("メモ一覧")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink(destination: AddMemoView()) {
              Image(systemName: "plus")
            }
          }
        }
      }
    }
}

extension MemoListView {
  // Save
  func saveMemo(newMemo: MemoItem) {
    if var memoItem = memos.first(where: { $0.id == newMemo.id }) {
      memoItem.title = newMemo.title
      memoItem.content = newMemo.content
    } else {
      modelContext.insert(newMemo)
    }

    do {
      try modelContext.save()
    } catch {
      print("Failed to save data: \(error)")
    }
  }

  // Delete
  private func deleteMemo(at offsets: IndexSet) {
      for index in offsets {
        let memo = memos[index]
        modelContext.delete(memo)
      }
      do {
        try modelContext.save()
      } catch {
        print("Failed to save data: \(error)")
      }
    }
}
