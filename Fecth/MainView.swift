import Foundation
import SwiftUI

struct MainView: View {
    @AppStorage("loggedInUserName") var loggedInUserName: String = ""
    @AppStorage("loggedInUserRole") var loggedInUserRole: String = ""
    @Binding var isLoggedIn: Bool // Adiciona o estado de login como binding

    var body: some View {
        VStack {
            Text("Bem-vindo, \(loggedInUserName)!")
                .font(.largeTitle)
                .padding()

            Text("Seu papel: \(loggedInUserRole)")
                .font(.title2)
                .padding()

            if loggedInUserRole == "admin" {
                Text("Admin Panel")
                    .font(.title)
                    .padding()
                // Adicionar mais funcionalidades específicas de admin aqui
            } else if loggedInUserRole == "tecnico" {
                Text("Técnico Dashboard")
                    .font(.title)
                    .padding()
                // Adicionar mais funcionalidades específicas de técnico aqui
            }

            Button("Logout") {
                logout() // Ação de logout
            }
            .padding()
            .foregroundColor(.red)
        }
    }
    
    func logout() {
        // Limpa as informações armazenadas
        loggedInUserName = ""
        loggedInUserRole = ""
        isLoggedIn = false // Atualiza o estado para deslogar o usuário
    }
}



