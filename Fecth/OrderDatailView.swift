import SwiftUI

struct OrderDetailView: View {

    let order: Order 

    var body: some View {

        Form {

            Section("Pedido") {

                HStack {
                    Text("Número")
                    Spacer()
                    Text("#\(order.id)")
                }

                HStack {
                    Text("Produto")
                    Spacer()
                    Text(order.item.name)
                }

                HStack {
                    Text("Status")
                    Spacer()
                    Text(order.status)
                        .foregroundColor(corStatus())
                }
            }

            Section("Ações") {

                Button("Atualizar") { }

                Button("Cancelar Pedido") { }
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Pedido")
    }

    private func corStatus() -> Color {

        switch order.status {

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
