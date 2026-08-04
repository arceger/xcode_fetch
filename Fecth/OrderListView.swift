import SwiftUI

struct OrderListView: View {

    @State private var orders = [
        Order(
            id: 1,
            creationDate: "2026-08-04T10:15:00",
            quantidade: 2,
            status: "COMPLETO",
            item: Item(id: 1, name: "Notebook")
        ),
        Order(
            id: 2,
            creationDate: "2026-08-04T11:30:00",
            quantidade: 1,
            status: "PENDENTE",
            item: Item(id: 2, name: "Mouse")
        )
    ]

    var body: some View {

        List(orders) { order in

            NavigationLink(destination: OrderDetailView(order: order)) {

                VStack(alignment: .leading, spacing: 8) {

                    HStack {

                        Text(order.item.name)
                            .font(.headline)

                        Spacer()

                        Text(order.status)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(statusColor(order.status).opacity(0.2))
                            .foregroundColor(statusColor(order.status))
                            .cornerRadius(8)
                    }

                    Text("Quantidade: \(order.quantidade)")
                        .font(.subheadline)

                    Text("Pedido #\(order.id)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Meus Pedidos")
    }

    private func statusColor(_ status: String) -> Color {

        switch status {

        case "COMPLETO":
            return .green

        case "PENDENTE":
            return .orange

        case "CANCELADO":
            return .red

        default:
            return .gray
        }
    }
}

#Preview {

    NavigationStack {
        OrderListView()
    }
}

