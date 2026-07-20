
import SwiftUI


struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField("Kiriting", text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }
}

struct DropdownField: View {
    let title: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            if !title.isEmpty {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Menu {
                ForEach(options, id: \.self) { item in
                    Button(item) {
                        selection = item
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? "Tanlang" : selection)
                        .foregroundColor(selection.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
    }
}


// MARK: - Reusable Input Component
struct LoginInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding()
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
            )
        }
    }
}
