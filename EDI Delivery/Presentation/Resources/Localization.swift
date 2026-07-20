import SwiftUI
internal import Combine

// MARK: - Supported languages

enum AppLanguage: String, CaseIterable {
    case uz
    case ru
    case en

    /// Name shown in the language picker, written in the language itself.
    var nativeName: String {
        switch self {
        case .uz: return "O'zbekcha"
        case .ru: return "Русский"
        case .en: return "English"
        }
    }

    var flag: String {
        switch self {
        case .uz: return "🇺🇿"
        case .ru: return "🇷🇺"
        case .en: return "🇬🇧"
        }
    }
}

// MARK: - Localization manager

/// Holds the in-app selected language. Persists it in `Cache` and, on change,
/// asks `AppCoordinator` to rebuild the root so every UIKit title and SwiftUI
/// string is re-evaluated in the new language.
final class LocalizationManager: ObservableObject {

    static let shared = LocalizationManager()

    @Published private(set) var language: AppLanguage

    private init() {
        self.language = AppLanguage(rawValue: Cache.share.getLanguage() ?? "") ?? .uz
    }

    func setLanguage(_ language: AppLanguage) {
        guard language != self.language else { return }
        self.language = language
        Cache.share.saveLanguage(language.rawValue)
        DispatchQueue.main.async {
            AuthSession.delegate?.reloadRoot()
        }
    }

    func string(for key: LKey) -> String {
        let t = key.translations
        switch language {
        case .uz: return t.uz
        case .ru: return t.ru
        case .en: return t.en
        }
    }
}

/// Shorthand lookup used throughout the UI: `L(.save)`.
func L(_ key: LKey) -> String {
    LocalizationManager.shared.string(for: key)
}

// MARK: - Interpolated strings

/// Helpers for strings that embed a runtime value.
enum Loc {

    static func greeting(_ name: String) -> String {
        switch LocalizationManager.shared.language {
        case .uz: return "Salom, \(name)"
        case .ru: return "Привет, \(name)"
        case .en: return "Hello, \(name)"
        }
    }

    /// "12 ta" / "12 шт" / "12 pcs"
    static func quantity(_ value: some CustomStringConvertible) -> String {
        switch LocalizationManager.shared.language {
        case .uz: return "\(value) ta"
        case .ru: return "\(value) шт"
        case .en: return "\(value) pcs"
        }
    }
}

// MARK: - Keys

enum LKey {

    // Navigation / screen titles
    case profile
    case orders
    case order
    case products
    case salesPoints
    case report
    case submit
    case selectDate
    case home
    case orderDetail

    // Main menu tiles
    case menuOrders
    case menuSale
    case menuProducts
    case menuBranches
    case menuReport

    // Common actions
    case cancel
    case confirm
    case save
    case clear
    case close
    case back
    case logout
    case deleteAccount
    case filter
    case language
    case search

    // Profile
    case organization
    case logoutConfirmMessage
    case deleteAccountConfirmMessage

    // Login
    case loginField
    case password
    case enterPassword
    case signIn

    // Empty states
    case nothingFound
    case noBranches
    case noOrders
    case noProducts
    case noSales
    case basketEmpty

    // Basket
    case agreeHandover
    case clearBasket
    case clearBasketConfirm
    case cash
    case byTerminal
    case saleType
    case selectSaleType
    case quantityLabel
    case totalQuantity
    case itemUpdated
    case saleTypeElectronic
    case saleTypeFiscal
    case noProductsInBasket
    case basketNotEmpty
    case addProduct
    case salePointNotSelected
    case tapToAddProduct
    case enterPaymentAmount
    case submittedSuccess

    // Forms (branches / clients)
    case client
    case clientRequired
    case selectClient
    case clientInfo
    case branchInfo
    case location
    case addClient
    case addBranch
    case newBranch
    case newClient
    case editBranch
    case edit
    case view
    case addToBasket
    case branchName
    case branchNameRequired
    case branchCode
    case branchCodeRequired
    case code
    case address
    case streetHouse
    case region
    case selectRegion
    case district
    case selectDistrict
    case fullName
    case clientName
    case clientCodeRequired
    case phoneNineDigits
    case optional
    case branchAdded
    case branchUpdated
    case clientAdded
    case fillAllRequired
    case fillRequired
    case fillClientAndRequired

    // Products
    case barcode
    case ikpuCode
    case ikpuName
    case packageCode
    case packageName
    case vatRate
    case price
    case unit
    case productHasNoUnit
    case enterQuantity
    case addedToBasket

    // Orders
    case totalValue
    case startSale
    case unitPiece
    case totalAmount
    case basketHasOtherProducts
    case saleConversionError
    case orderCancelled

    // Documents
    case document
    case saleNumber
    case branch
    case contract
    case vat

    // Network / toasts
    case serverError
    case dataError
    case noInternet
    case sessionEnded
    case alreadyExists
    case requestFailed

    var translations: (uz: String, ru: String, en: String) {
        switch self {

        case .profile:        return ("Profil", "Профиль", "Profile")
        case .orders:         return ("Buyurtmalar", "Заказы", "Orders")
        case .order:          return ("Buyurtma", "Заказ", "Order")
        case .products:       return ("Mahsulotlar", "Товары", "Products")
        case .salesPoints:    return ("Savdo nuqtalari", "Торговые точки", "Sales points")
        case .report:         return ("Hisobot", "Отчёт", "Report")
        case .submit:         return ("Topshirish", "Сдать", "Submit")
        case .selectDate:     return ("Sana tanlang", "Выберите дату", "Select date")
        case .home:           return ("Bosh sahifa", "Главная", "Home")

        case .menuOrders:     return ("Buyurtmalar", "Заказы", "Orders")
        case .menuSale:       return ("Sotuv", "Продажа", "Sale")
        case .menuProducts:   return ("Mahsulotlar", "Товары", "Products")
        case .menuBranches:   return ("Savdo nuqtalari", "Торговые точки", "Sales points")
        case .menuReport:     return ("Hisobot", "Отчёт", "Report")

        case .cancel:         return ("Bekor qilish", "Отмена", "Cancel")
        case .confirm:        return ("Tasdiqlash", "Подтвердить", "Confirm")
        case .save:           return ("Saqlash", "Сохранить", "Save")
        case .clear:          return ("Tozalash", "Очистить", "Clear")
        case .close:          return ("Yopish", "Закрыть", "Close")
        case .back:           return ("Orqaga", "Назад", "Back")
        case .logout:         return ("Chiqish", "Выход", "Log out")
        case .deleteAccount:  return ("Hisobni o'chirish", "Удалить аккаунт", "Delete account")
        case .filter:         return ("Filterlash", "Фильтр", "Filter")
        case .language:       return ("Til", "Язык", "Language")
        case .search:         return ("Qidirish", "Поиск", "Search")

        case .organization:   return ("Tashkilot", "Организация", "Organization")
        case .logoutConfirmMessage:
            return ("Hisobdan chiqmoqchimisiz?", "Вы хотите выйти из аккаунта?", "Are you sure you want to log out?")
        case .deleteAccountConfirmMessage:
            return ("Hisobingizni o'chirmoqchimisiz? Bu amalni qaytarib bo'lmaydi.", "Удалить аккаунт? Это действие необратимо.", "Delete your account? This action cannot be undone.")

        case .loginField:     return ("Login", "Логин", "Login")
        case .password:       return ("Parol", "Пароль", "Password")
        case .enterPassword:  return ("Parolni kiriting", "Введите пароль", "Enter your password")
        case .signIn:         return ("Kirish", "Войти", "Sign in")

        case .nothingFound:   return ("Hech narsa topilmadi", "Ничего не найдено", "Nothing found")
        case .noBranches:     return ("Filiallar topilmadi", "Филиалы не найдены", "No branches found")
        case .noOrders:       return ("Buyurtmalar topilmadi", "Заказы не найдены", "No orders found")
        case .noProducts:     return ("Mahsulotlar topilmadi", "Товары не найдены", "No products found")
        case .noSales:        return ("Sotuvlar topilmadi", "Продажи не найдены", "No sales found")
        case .basketEmpty:    return ("Savat bo'sh", "Корзина пуста", "The basket is empty")

        case .agreeHandover:
            return ("Tovarni topshirishga roziman", "Согласен передать товар", "I agree to hand over the goods")
        case .clearBasket:    return ("Savatni tozalash", "Очистить корзину", "Clear basket")
        case .clearBasketConfirm:
            return ("Savat to'liq tozalanadi. Davom etasizmi?", "Корзина будет полностью очищена. Продолжить?", "The basket will be fully cleared. Continue?")
        case .cash:           return ("Naqd orqali", "Наличными", "Cash")
        case .byTerminal:     return ("Terminal orqali", "Через терминал", "By terminal")
        case .saleType:       return ("Sotuv turi", "Тип продажи", "Sale type")
        case .selectSaleType: return ("Sotuv turini tanlang", "Выберите тип продажи", "Select sale type")
        case .quantityLabel:  return ("Miqdor", "Количество", "Quantity")
        case .totalQuantity:  return ("Jami soni", "Общее количество", "Total quantity")
        case .itemUpdated:    return ("O'zgartirildi", "Изменено", "Updated")
        case .saleTypeElectronic:
            return ("Elektron hisob faktura orqali", "Через электронный счёт-фактуру", "Via electronic invoice")
        case .saleTypeFiscal:
            return ("OFD fiskal chek orqali", "Через фискальный чек ОФД", "Via OFD fiscal receipt")
        case .noProductsInBasket:
            return ("Savatda mahsulot yo'q", "В корзине нет товаров", "No products in the basket")
        case .basketNotEmpty:
            return ("Savatda mahsulot bor. Avval uni tugating yoki tozalang.", "В корзине есть товары. Сначала завершите или очистите её.", "The basket already has items. Finish or clear it first.")
        case .addProduct:     return ("Mahsulot qo'shish", "Добавить товар", "Add product")
        case .salePointNotSelected:
            return ("Savdo nuqtasi tanlanmagan", "Торговая точка не выбрана", "Sale point not selected")
        case .tapToAddProduct:
            return ("Tovarlar topilmadi\nMahsulot qo'shish uchun bosing", "Товары не найдены\nНажмите, чтобы добавить товар", "No products\nTap to add a product")
        case .enterPaymentAmount:
            return ("To'lov summasini kiriting", "Введите сумму оплаты", "Enter the payment amount")
        case .submittedSuccess:
            return ("Muvaffaqiyatli topshirildi", "Успешно сдано", "Submitted successfully")

        case .client:             return ("Mijoz:", "Клиент:", "Client:")
        case .clientRequired:     return ("Mijoz *", "Клиент *", "Client *")
        case .selectClient:       return ("Mijoz tanlang", "Выберите клиента", "Select a client")
        case .clientInfo:         return ("Mijoz ma'lumotlari", "Информация о клиенте", "Client details")
        case .branchInfo:         return ("Filial ma'lumotlari", "Информация о филиале", "Branch details")
        case .location:           return ("Joylashuv", "Местоположение", "Location")
        case .addClient:          return ("Mijoz qo'shish", "Добавить клиента", "Add client")
        case .addBranch:          return ("Filial qo'shish", "Добавить филиал", "Add branch")
        case .newBranch:          return ("Yangi filial", "Новый филиал", "New branch")
        case .newClient:          return ("Yangi mijoz", "Новый клиент", "New client")
        case .editBranch:         return ("Filialni tahrirlash", "Редактировать филиал", "Edit branch")
        case .edit:               return ("Tahrirlash", "Редактировать", "Edit")
        case .view:               return ("Ko'rish", "Просмотр", "View")
        case .addToBasket:        return ("Savatga qo'shish", "Добавить в корзину", "Add to basket")
        case .branchName:         return ("Filial nomi", "Название филиала", "Branch name")
        case .branchNameRequired: return ("Filial nomi *", "Название филиала *", "Branch name *")
        case .branchCode:         return ("Filial kodi", "Код филиала", "Branch code")
        case .branchCodeRequired: return ("Filial kodi *", "Код филиала *", "Branch code *")
        case .code:               return ("Kod", "Код", "Code")
        case .address:            return ("Manzil", "Адрес", "Address")
        case .streetHouse:        return ("Ko'cha, uy...", "Улица, дом...", "Street, house...")
        case .region:             return ("Viloyat", "Область", "Region")
        case .selectRegion:       return ("Viloyat tanlang", "Выберите область", "Select a region")
        case .district:           return ("Tuman", "Район", "District")
        case .selectDistrict:     return ("Tuman tanlang", "Выберите район", "Select a district")
        case .fullName:           return ("Ismi *", "Имя *", "Name *")
        case .clientName:         return ("Mijoz ismi", "Имя клиента", "Client name")
        case .clientCodeRequired: return ("Mijoz kodi *", "Код клиента *", "Client code *")
        case .phoneNineDigits:    return ("Telefon * (9 raqam)", "Телефон * (9 цифр)", "Phone * (9 digits)")
        case .optional:           return ("Ixtiyoriy", "Необязательно", "Optional")
        case .branchAdded:
            return ("Filial muvaffaqiyatli qo'shildi", "Филиал успешно добавлен", "Branch added successfully")
        case .branchUpdated:
            return ("Filial yangilandi", "Филиал обновлён", "Branch updated")
        case .clientAdded:
            return ("Mijoz muvaffaqiyatli qo'shildi", "Клиент успешно добавлен", "Client added successfully")
        case .fillAllRequired:
            return ("Barcha majburiy maydonlarni to'ldiring", "Заполните все обязательные поля", "Fill in all required fields")
        case .fillRequired:
            return ("Majburiy maydonlarni to'ldiring", "Заполните обязательные поля", "Fill in the required fields")
        case .fillClientAndRequired:
            return ("Mijoz va majburiy maydonlarni to'ldiring", "Выберите клиента и заполните обязательные поля", "Select a client and fill in the required fields")

        case .barcode:        return ("Shtrix kodi", "Штрихкод", "Barcode")
        case .ikpuCode:       return ("IKPU kod", "Код ИКПУ", "IKPU code")
        case .ikpuName:       return ("IKPU nomi", "Наименование ИКПУ", "IKPU name")
        case .packageCode:    return ("Paket kod", "Код упаковки", "Package code")
        case .packageName:    return ("Paket nomi", "Наименование упаковки", "Package name")
        case .vatRate:        return ("QQS stavka", "Ставка НДС", "VAT rate")
        case .price:          return ("Narx", "Цена", "Price")
        case .unit:           return ("Birlik", "Единица", "Unit")
        case .productHasNoUnit:
            return ("Mahsulotda birlik mavjud emas", "У товара нет единицы измерения", "The product has no unit")
        case .enterQuantity:  return ("Miqdorni kiriting", "Введите количество", "Enter the quantity")
        case .addedToBasket:  return ("Savatga qo'shildi", "Добавлено в корзину", "Added to the basket")

        case .totalValue:     return ("Jami qiymati:", "Общая стоимость:", "Total value:")
        case .startSale:      return ("Sotuvni boshlash", "Начать продажу", "Start sale")
        case .unitPiece:      return ("dona", "шт", "pcs")
        case .totalAmount:    return ("Jami summa", "Итого", "Total amount")
        case .basketHasOtherProducts:
            return ("Savatda boshqa mahsulotlar mavjud.", "В корзине есть другие товары.", "The basket contains other products.")
        case .saleConversionError:
            return ("Savdoga o'tkazish bilan xatolik mavjud.", "Ошибка при переходе к продаже.", "An error occurred while starting the sale.")
        case .orderCancelled:
            return ("Buyurtma bekor qilindi", "Заказ отменён", "Order cancelled")

        case .document:       return ("Hujjat", "Документ", "Document")
        case .saleNumber:     return ("Sotuv raqami", "Номер продажи", "Sale number")
        case .branch:         return ("Filial", "Филиал", "Branch")
        case .contract:       return ("Shartnoma", "Договор", "Contract")
        case .vat:            return ("QQS", "НДС", "VAT")

        case .serverError:
            return ("Serverda xatolik yuz berdi", "Произошла ошибка на сервере", "A server error occurred")
        case .dataError:      return ("Ma'lumotlar xatosi", "Ошибка данных", "Data error")
        case .noInternet:
            return ("Internetga ulanib bo'lmadi. Wi-Fi yoki mobil internetni tekshiring va qaytadan urinib ko'ring",
                    "Не удалось подключиться к интернету. Проверьте Wi-Fi или мобильный интернет и повторите попытку",
                    "Could not connect to the internet. Check your Wi-Fi or mobile data and try again")
        case .sessionEnded:
            return ("Sessiya tugadi. Qaytadan kiring.", "Сессия завершена. Войдите снова.", "Your session has expired. Please sign in again.")
        case .alreadyExists:
            return ("Bu ma'lumot allaqachon mavjud", "Эти данные уже существуют", "This record already exists")
        case .requestFailed:
            return ("Amalni bajarib bo'lmadi", "Не удалось выполнить действие", "The request could not be completed")
        case .orderDetail:
            return ("Buyurtma tafsilotlari", "Детали заказа", "Order Details")
        }
    }
}
