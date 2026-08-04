struct Order: Identifiable, Codable {

    let id: Int
    let creationDate: String?
    let quantidade: Int
    let status: String
    let item: Item
}

struct Item: Codable, Hashable, Identifiable {

    let id: Int
    let name: String
}
