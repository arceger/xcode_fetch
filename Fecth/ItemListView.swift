import SwiftUI

struct ItemListView: View {

    @State private var items = [
        Item(id: 1, name: "Notebook"),
        Item(id: 2, name: "Mouse"),
        Item(id: 3, name: "Teclado"),
        Item(id: 4, name: "Monitor")
    ]

    var body: some View {

        List(items) { item in

            HStack {

                Image(systemName: "shippingbox")
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {

                    Text(item.name)
                        .font(.headline)

                    Text("ID: \(item.id)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("Produtos")
    }
}

#Preview {
    NavigationStack {
        ItemListView()
    }
}

