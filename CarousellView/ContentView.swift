import SwiftUI

struct ContentView: View {
    @State private var currentIndex: Int? = 5
    @State private var task: Task<Void, Never>?
    private let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 1", "Item 2", "Item 3", "Item 4", "Item 1", "Item 2", "Item 3", "Item 4"]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .center) {
                ForEach(items.indices, id: \.self) { item in
                    Text(items[item]).frame(width: 300, height: 50).border(.blue)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $currentIndex)
        .onChange(of: currentIndex ?? 0) { oldValue, newValue in
            task?.cancel()
            task = Task {
                do {
                    try await Task.sleep(nanoseconds: 1000000000) // 1 Sec delay
                    if let currentIndex, currentIndex >= items.count - 2 {
                        self.currentIndex = items.firstIndex(of: items[currentIndex])
                    } else if let currentIndex, currentIndex <= 1 {
                        self.currentIndex = items.lastIndex(of: items[currentIndex])
                    }
                } catch {
                    print("Debounce")
                }
            }
        }
        .safeAreaPadding(.horizontal, 40)
    }
}

