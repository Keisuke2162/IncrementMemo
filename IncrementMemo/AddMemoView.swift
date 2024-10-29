//
//  AddMemoView.swift
//  IncrementMemo
//
//  Created by Kei on 2024/10/30.
//

import SwiftData
import SwiftUI

struct AddMemoView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  @State private var title: String = ""
  @State private var content: String = ""

  var body: some View {
      Form {
        Section(header: Text("タイトル")) {
          TextField("", text: $title)
        }

        Section(header: Text("内容")) {
          TextEditor(text: $content)
            .frame(minHeight: 150)
        }

        Button("保存") {
          let newMemo = MemoItem(title: title, content: content)
          modelContext.insert(newMemo)
          do {
            try modelContext.save()
            dismiss()
          } catch {
            print("Failed to save data: \(error)")
          }
        }
      }
      .navigationTitle("新規メモ")
    }
}
