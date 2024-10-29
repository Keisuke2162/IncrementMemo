import SwiftUI
import SwiftData

struct MemoDetailView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) private var dismiss
  private var memo: MemoItem
  @State private var title: String
  @State private var content: String
  @State private var numbers: [Int] = []
  @State private var isCopied = false

  init(memo: MemoItem) {
    self.memo = memo
    _title = State(initialValue: memo.title)
    _content = State(initialValue: memo.content)
  }
  
  var body: some View {
    VStack {
      Form {
        Section(header: Text("タイトル")) {
          TextField("", text: $title)
        }
        Section(header: Text("内容")) {
          TextEditor(text: $content)
            .frame(minHeight: 150)
        }
        // クリップボードにコピー
        Section {
          Button(action: {
            UIPasteboard.general.string = content
            isCopied = true
            // 1秒後にコピー完了表示を終了
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              isCopied = false
            }
          }) {
            Text(isCopied ? "コピー完了" : "コピー")
              .foregroundColor(.blue)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding()
          }
          .buttonStyle(BorderlessButtonStyle())
          .frame(height: 2)
        }
        Section(header: Text("数値の操作")) {
          ForEach(numbers.indices, id: \.self) { index in
            HStack {
              
              
              Text("\(numbers[index])")
              
              Spacer()
              Button {
                numbers[index] -= 1
                updateContent()
              } label: {
                Image(systemName: "minus.circle.fill")
                  .font(.system(size: 24))
                  .foregroundColor(.red)
                  .frame(width: 32, height: 32)
              }
              .buttonStyle(BorderlessButtonStyle())
              Spacer().frame(width: 32)
              Button {
                numbers[index] += 1
                updateContent()
              } label: {
                Image(systemName: "plus.circle.fill")
                  .font(.system(size: 24))
                  .foregroundColor(.blue)
                  .frame(width: 32, height: 32)
              }
              .buttonStyle(BorderlessButtonStyle())
            }
            .contentShape(Rectangle())
          }
        }
      }
      .onAppear {
        readNumbers(from: content)
      }
      
      Button("保存") {
        memo.title = title
        memo.content = content
        do {
          try modelContext.save()
          dismiss()
        } catch {
          print("Failed to save data: \(error)")
        }
      }
      .frame(width: 150, height: 40)
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(10)
      .padding()
    }
    
  }
  
  private func readNumbers(from text: String) {
    let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
    let nsString = text as NSString
    let results = regex.matches(in: text, options: [], range: NSRange(location: 0, length: nsString.length))
    
    numbers = results.compactMap {
      Int(nsString.substring(with: $0.range))
    }
  }
  
  private func updateContent() {
    var updatedContent = content
    
    let regex = try! NSRegularExpression(pattern: "\\d+", options: [])
    let nsString = updatedContent as NSString
    
    let ranges = regex.matches(in: updatedContent, options: [], range: NSRange(location: 0, length: nsString.length))
    
    for (index, match) in ranges.enumerated() {
      if index < numbers.count {
        let numberString = "\(numbers[index])"
        let range = match.range
        updatedContent = (updatedContent as NSString).replacingCharacters(in: range, with: numberString)
      }
    }
    
    content = updatedContent
  }
}
