import SwiftUI

struct ContentView: View {
    @State private var currentIndex: Int? = 5
    @State private var task: Task<Void, Never>?
    @State private var buffer: [(Range<Array<String>.Index>.Element, String)] = []
    private let items = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 1", "Item 2", "Item 3", "Item 4", "Item 1", "Item 2", "Item 3", "Item 4"]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(alignment: .center) {
                ForEach(buffer, id: \.0) { index in
                    Text(items[index.0]).frame(width: 300, height: 50).border(.blue)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $currentIndex)
        .onChange(of: currentIndex ?? 0) { oldValue, newValue in
            task?.cancel() // Debounce
            task = Task {
                do {
                    // Consider managing these in an actor class so that the buffer management can be serialized, because you can only scroll via user interaction or timer one at a time.
                    
                    try await Task.sleep(nanoseconds: 1000000000) // 1 Sec delay
                    
                    if currentIndex == items.count - 1 {
                        // end of index, you prolly want to prefetch more items to the end of the buffer now
                    } else if currentIndex == 0 {
                        // start of index, you prolly want to prefetch more items to the start of the buffer now
                    }
                    
                    // Moving buffer window here.
                    if newValue < oldValue, let item = buffer.popLast() {
                        buffer.insert(item, at: 0)
                    }
                    
                    if newValue > oldValue {
                        let item = buffer.removeFirst()
                        buffer.append(item)
                    }
                } catch {
                    print("Debounce")
                }
            }
        }
        .safeAreaPadding(.horizontal, 40)
        .onAppear {
            buffer = Array(zip(items.indices, items))
        }
    }
}

