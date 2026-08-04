import SwiftUI

struct CreateOrderView: View {

    @State private var selectedItem: Item?
    @State private var quantity = 1

    // Temporário
    @State private var items = [
        Item(id: 1, name: "Notebook"),
        Item(id: 2, name: "Mouse"),
        Item(id: 3, name: "Teclado")
    ]

    var body: some View {

        Form {

            Section("Produto") {

                Picker("Selecione", selection: $selectedItem) {

                    Text("Escolha um produto")
                        .tag(nil as Item?)

                    ForEach(items, id: \.id) { item in
                        Text(item.name)
                            .tag(Optional(item))
                    }
                }
            }

            Section("Quantidade") {

                Stepper(value: $quantity, in: 1...100) {

                    Text("\(quantity)")
                }
            }

            Section {

                Button {

                    criarPedido()

                } label: {

                    HStack {
                        Spacer()
                        Text("Criar Pedido")
                        Spacer()
                    }
                }
                .disabled(selectedItem == nil)
            }
        }
        .navigationTitle("Novo Pedido")
    }

    private func criarPedido() {

        guard let item = selectedItem else {
            return
        }

        print("Criar pedido")
        print(item.id)
        print(quantity)

        // próxima etapa:
        // OrderService.create(...)
    }
}

#Preview {

    NavigationStack {
        CreateOrderView()
    }
}
