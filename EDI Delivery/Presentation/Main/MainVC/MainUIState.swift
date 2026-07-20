internal import Foundation

struct MenuItem: Identifiable {
    let id = UUID()
    let number: Int
    let title: String
    let icon: String
}

struct MainUIState {
    var user: UserData?

    var menuItems: [MenuItem] = [
        MenuItem(number: 1, title: L(.menuOrders),   icon: "list.bullet.rectangle"),
        MenuItem(number: 2, title: L(.menuSale),     icon: "cart"),
        MenuItem(number: 3, title: L(.menuProducts), icon: "shippingbox"),
        MenuItem(number: 4, title: L(.menuBranches), icon: "mappin.and.ellipse"),
        MenuItem(number: 5, title: L(.menuReport),   icon: "doc.plaintext"),
    ]
}
