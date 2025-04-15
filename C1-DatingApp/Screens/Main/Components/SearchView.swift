import SwiftUI

struct SearchView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var icon: String = "magnifyingglass"
    var iconColor: Color = .gray
    var placeholder: String = ""
    var isAutoFocus: Bool = false
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(iconColor)

            TextField(placeholder, text: $text)
                .foregroundColor(.primary)
                .focused($isFocused)

            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        .onAppear {
            if isAutoFocus {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isFocused = true
                }
            }
        }
    }
}
