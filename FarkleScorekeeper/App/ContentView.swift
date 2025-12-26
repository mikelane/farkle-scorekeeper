import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "dice")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Farkle Scorekeeper")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
