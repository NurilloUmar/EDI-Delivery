internal import Foundation

enum LocalizedKey: String {
    // Common
    case common_cancel
    case common_ok
    case common_delete
    case common_save
    case common_error

    // Tab Bar
    case tab_dashboard
    case tab_partner
    case tab_document
    case tab_deal
    case tab_payment

    // Documents
    case documents_title
    case documents_search
    case documents_outgoing
    case documents_incoming
    case documents_count
    case documents_count_short
    case documents_summa
    case documents_qos
    case documents_qos_total
    case documents_sum
    case documents_from
    case documents_inn_label
    case documents_not_found
    case documents_type_all
    case documents_type_invoices
    case documents_type_acts
    case documents_type_contracts
    case documents_type_waybill
    case documents_type_empowerment
    case documents_type_verification_act
    case documents_type_free_form
    case documents_type_internal
    case documents_status_draft
    case documents_status_accepted
    case documents_status_rejected
    case documents_status_in_review
    case documents_status_cancelled
    case documents_status_unknown
    case documents_status_unselected

    // Login
    case login_username_title
    case login_username_placeholder
    case login_password_title
    case login_password_placeholder
    case login_button

    // Dashboard
    case dashboard_title
    case dashboard_tasks
    case dashboard_documents
    case dashboard_approval_documents
    case dashboard_show_all
    case dashboard_yesterday_open
    case dashboard_open
    case dashboard_completed
    case dashboard_cancelled
    case dashboard_not_sent
    case dashboard_pending
    case dashboard_invoice
    case dashboard_contracts
    case dashboard_acts
    case dashboard_others
    case dashboard_sent_total
    case dashboard_sent
    case dashboard_in_review
    case dashboard_in_progress
    case dashboard_approved
    case dashboard_declined
    case dashboard_cancelled_short
    case dashboard_expired

    // Profile
    case profile_title
    case profile_personal_info
    case profile_notifications
    case profile_about
    case profile_settings
    case profile_privacy
    case profile_language
    case profile_logout
    case profile_delete_account
    case profile_logout_alert_title
    case profile_logout_alert_message
    case profile_delete_alert_title
    case profile_delete_alert_message
    case profile_phone
    case profile_no_name
    case profile_language_picker_title
    case profile_language_picker_description

    // Partner
    case partner_title
    case partner_search_placeholder
    case partner_not_found
    case partner_status_all
    case partner_status_active
    case partner_status_inactive
    case partner_status_blocked
    case partner_status_unknown
    case partner_status_label
    case partner_inn
    case partner_no_name

    // Partner Detail
    case partner_detail_contracts
    case partner_detail_contact_info
    case partner_detail_brand
    case partner_detail_no_brand
    case partner_detail_balance
    case partner_detail_description
    case partner_detail_contacts
    case partner_detail_no_contacts
    case partner_detail_no_contracts
    case partner_detail_date_label
    case partner_detail_website

    // Contact Type
    case contact_phone
    case contact_telegram
    case contact_email
    case contact_other

    // Transaction Status
    case transaction_completed
    case transaction_pending
    case transaction_cancelled
    case transaction_unknown

    // Deal Detail
    case deal_detail_contract
    case deal_detail_number
    case deal_detail_date
    case deal_detail_partner
    case deal_detail_type
    case deal_detail_payment
    case deal_detail_document
    case deal_detail_loading
    case deal_detail_view_file
    case deal_detail_share_save
    case deal_detail_file_error
    case deal_detail_file_not_loaded
    case deal_detail_error_prefix

    // Payment Detail
    case payment_detail_title
    case payment_detail_main
    case payment_detail_doc_number
    case payment_detail_amount
    case payment_detail_receiver
    case payment_detail_stir
    case payment_detail_date
    case payment_detail_status
    case payment_detail_details
    case payment_detail_contract_label
    case payment_detail_id_label
    case payment_detail_comment_label
    case payment_detail_sender_label
    case payment_detail_receiver_label
    case payment_detail_stir_inn
    case payment_detail_mfo
    case payment_detail_account

    // Deal
    case deal_title
    case deal_not_found
    case deal_partner_label
    case deal_status_label

    // Payment
    case payment_title
    case payment_income
    case payment_outcome
    case payment_no_data
    case payment_unknown
    case payment_inn

    // Common UI
    case search_placeholder
    case search_empty

    // Errors
    case error_server
    case error_session_expired
    case error_no_internet
    case error_data
    case error_invalid_url
}

enum Localizations {

    static let dictionary: [AppLanguage: [LocalizedKey: String]] = [
        .uz: uzbek,
        .ru: russian,
        .en: english
    ]

    private static let uzbek: [LocalizedKey: String] = [
        // Common
        .common_cancel: "Bekor qilish",
        .common_ok: "OK",
        .common_delete: "O'chirish",
        .common_save: "Saqlash",
        .common_error: "Xatolik",

        // Tab Bar
        .tab_dashboard: "Asosiy",
        .tab_partner: "Hamkorlar",
        .tab_document: "Hujjatlar",
        .tab_deal: "Shartnoma",
        .tab_payment: "To'lovlar",

        // Documents
        .documents_title: "Hujjatlar",
        .documents_search: "Hujjat raqami bo'yicha qidirish",
        .documents_outgoing: "Chiquvchi",
        .documents_incoming: "Kiruvchi",
        .documents_count: "ta hujjat",
        .documents_count_short: "ta",
        .documents_summa: "Summa",
        .documents_qos: "QQS",
        .documents_qos_total: "QQS bilan jami",
        .documents_sum: "so'm",
        .documents_from: "dan",
        .documents_inn_label: "INN",
        .documents_not_found: "Hujjatlar topilmadi",
        .documents_type_all: "Barchasi",
        .documents_type_invoices: "Schyot-fakturalar",
        .documents_type_acts: "Aktlar",
        .documents_type_contracts: "Shartnomalar",
        .documents_type_waybill: "Yo'l varaqasi",
        .documents_type_empowerment: "Ishonchnoma",
        .documents_type_verification_act: "Solishtirish dalolatnomasi",
        .documents_type_free_form: "Erkin shakl",
        .documents_type_internal: "Ichki hujjat",
        .documents_status_draft: "Qoralama",
        .documents_status_accepted: "Mijoz / hamkor tomonidan qabul qilindi",
        .documents_status_rejected: "Rad etilgan",
        .documents_status_in_review: "Ko'rib chiqilmoqda",
        .documents_status_cancelled: "Bekor qilingan",
        .documents_status_unknown: "Noma'lum",
        .documents_status_unselected: "Tanlanmagan",

        // Login
        .login_username_title: "Login",
        .login_username_placeholder: "Loginni kiriting",
        .login_password_title: "Parol",
        .login_password_placeholder: "*****",
        .login_button: "Tizimga kirish",

        // Dashboard
        .dashboard_title: "Boshqaruv paneli",
        .dashboard_tasks: "Vazifalar",
        .dashboard_documents: "Hujjatlar",
        .dashboard_approval_documents: "Kelishuv hujjatlari",
        .dashboard_show_all: "Barchasi →",
        .dashboard_yesterday_open: "Kechagi ochiq",
        .dashboard_open: "Ochiq",
        .dashboard_completed: "Bajarilgan",
        .dashboard_cancelled: "Bekor qilingan",
        .dashboard_not_sent: "Kelishuvga yuborilmagan",
        .dashboard_pending: "Kutilmoqda",
        .dashboard_invoice: "Schyot-faktura",
        .dashboard_contracts: "Shartnomalar",
        .dashboard_acts: "Aktlar",
        .dashboard_others: "Boshqalar",
        .dashboard_sent_total: "Kelishuvga yuborilgan",
        .dashboard_sent: "Yuborilgan",
        .dashboard_in_review: "Kelishuvda",
        .dashboard_in_progress: "Jarayonda",
        .dashboard_approved: "Kelishilgan",
        .dashboard_declined: "Rad etilgan",
        .dashboard_cancelled_short: "Bekor",
        .dashboard_expired: "Muddati o'tgan",

        // Profile
        .profile_title: "Profil",
        .profile_personal_info: "Shaxsiy ma'lumotlar",
        .profile_notifications: "Bildirishnoma",
        .profile_about: "Ilova haqida",
        .profile_settings: "Sozlamalar",
        .profile_privacy: "Maxfiylik siyosati",
        .profile_language: "Til",
        .profile_logout: "Chiqish",
        .profile_delete_account: "Hisobni o'chirish",
        .profile_logout_alert_title: "Chiqish",
        .profile_logout_alert_message: "Haqiqatan ham hisobingizdan chiqmoqchimisiz?",
        .profile_delete_alert_title: "Hisobni o'chirish",
        .profile_delete_alert_message: "Diqqat! Hisobingizni o'chirib yuborsangiz, barcha ma'lumotlaringiz qayta tiklanmaydi.",
        .profile_phone: "Telefon",
        .profile_no_name: "Ismsiz",
        .profile_language_picker_title: "Tilni tanlang",
        .profile_language_picker_description: "Ilova interfeysi tili",

        // Partner
        .partner_title: "Hamkorlar",
        .partner_search_placeholder: "Kontragentlarni qidirish",
        .partner_not_found: "Kontragentlar topilmadi",
        .partner_status_all: "Barchasi",
        .partner_status_active: "Faol",
        .partner_status_inactive: "Nofaol",
        .partner_status_blocked: "Bloklangan",
        .partner_status_unknown: "Noma'lum",
        .partner_status_label: "Holat",
        .partner_inn: "INN",
        .partner_no_name: "Ismsiz",

        // Partner Detail
        .partner_detail_contracts: "Shartnomalar",
        .partner_detail_contact_info: "Aloqa ma'lumotlari",
        .partner_detail_brand: "Brend",
        .partner_detail_no_brand: "Brend nomi yo'q",
        .partner_detail_balance: "Balans",
        .partner_detail_description: "Tavsif",
        .partner_detail_contacts: "Kontaktlar",
        .partner_detail_no_contacts: "Kontakt ma'lumotlari yo'q",
        .partner_detail_no_contracts: "Shartnomalar yo'q",
        .partner_detail_date_label: "Sana",
        .partner_detail_website: "Veb-sayt",

        // Contact Type
        .contact_phone: "Telefon",
        .contact_telegram: "Telegram",
        .contact_email: "Email",
        .contact_other: "Kontakt",

        // Transaction Status
        .transaction_completed: "Tugatilgan",
        .transaction_pending: "Jarayonda",
        .transaction_cancelled: "Bekor qilingan",
        .transaction_unknown: "Noma'lum",

        // Deal Detail
        .deal_detail_contract: "Shartnoma",
        .deal_detail_number: "Raqam",
        .deal_detail_date: "Sana",
        .deal_detail_partner: "Kontragent",
        .deal_detail_type: "Turi",
        .deal_detail_payment: "To'lov",
        .deal_detail_document: "Hujjat",
        .deal_detail_loading: "Yuklanmoqda...",
        .deal_detail_view_file: "Faylni ko'rish",
        .deal_detail_share_save: "Ulashish / Saqlash",
        .deal_detail_file_error: "Xatolik",
        .deal_detail_file_not_loaded: "Fayl yuklanmadi",
        .deal_detail_error_prefix: "Xato",

        // Payment Detail
        .payment_detail_title: "To'lov topshirig'i",
        .payment_detail_main: "Asosiy",
        .payment_detail_doc_number: "Hujjat raqami",
        .payment_detail_amount: "Summa",
        .payment_detail_receiver: "Oluvchi",
        .payment_detail_stir: "STIR",
        .payment_detail_date: "Sana",
        .payment_detail_status: "Holat",
        .payment_detail_details: "Tafsilotlar",
        .payment_detail_contract_label: "Shartnoma raqami va sanasi",
        .payment_detail_id_label: "ID / To'lov ID",
        .payment_detail_comment_label: "To'lov mazmuni",
        .payment_detail_sender_label: "Mablag' yuboruvchi",
        .payment_detail_receiver_label: "Mablag' qabul qiluvchi",
        .payment_detail_stir_inn: "STIR / INN",
        .payment_detail_mfo: "MFO",
        .payment_detail_account: "Hisob raqami",

        // Deal
        .deal_title: "Shartnoma",
        .deal_not_found: "Shartnomalar topilmadi",
        .deal_partner_label: "Hamkor",
        .deal_status_label: "Holat",

        // Payment
        .payment_title: "To'lovlar",
        .payment_income: "↑ Kirim",
        .payment_outcome: "↓ Chiqim",
        .payment_no_data: "Ma'lumotlar mavjud emas",
        .payment_unknown: "Noma'lum",
        .payment_inn: "INN",

        // Common UI
        .search_placeholder: "Qidirish",
        .search_empty: "Hech narsa topilmadi",

        // Errors
        .error_server: "Serverda xatolik yuz berdi",
        .error_session_expired: "Sessiya tugadi. Qaytadan kiring.",
        .error_no_internet: "Internetga ulanib bo'lmadi. Wi-Fi yoki mobil internetni tekshiring va qaytadan urinib ko'ring",
        .error_data: "Ma'lumotlar xatosi",
        .error_invalid_url: "Noto'g'ri URL manzili"
    ]

    private static let russian: [LocalizedKey: String] = [
        // Common
        .common_cancel: "Отмена",
        .common_ok: "OK",
        .common_delete: "Удалить",
        .common_save: "Сохранить",
        .common_error: "Ошибка",

        // Tab Bar
        .tab_dashboard: "Главная",
        .tab_partner: "Партнёры",
        .tab_document: "Документы",
        .tab_deal: "Договоры",
        .tab_payment: "Платежи",

        // Documents
        .documents_title: "Документы",
        .documents_search: "Поиск по номеру документа",
        .documents_outgoing: "Исходящие",
        .documents_incoming: "Входящие",
        .documents_count: "документов",
        .documents_count_short: "шт",
        .documents_summa: "Сумма",
        .documents_qos: "НДС",
        .documents_qos_total: "Всего с НДС",
        .documents_sum: "сум",
        .documents_from: "от",
        .documents_inn_label: "ИНН",
        .documents_not_found: "Документы не найдены",
        .documents_type_all: "Все",
        .documents_type_invoices: "Счёт-фактуры",
        .documents_type_acts: "Акты",
        .documents_type_contracts: "Договоры",
        .documents_type_waybill: "ТТН",
        .documents_type_empowerment: "Доверенность",
        .documents_type_verification_act: "Акт сверки",
        .documents_type_free_form: "Свободная форма",
        .documents_type_internal: "Внутренний",
        .documents_status_draft: "Черновик",
        .documents_status_accepted: "Принят клиентом / партнёром",
        .documents_status_rejected: "Отклонён",
        .documents_status_in_review: "На рассмотрении",
        .documents_status_cancelled: "Отменён",
        .documents_status_unknown: "Неизвестно",
        .documents_status_unselected: "Не выбрано",

        // Login
        .login_username_title: "Логин",
        .login_username_placeholder: "Введите логин",
        .login_password_title: "Пароль",
        .login_password_placeholder: "*****",
        .login_button: "Войти",

        // Dashboard
        .dashboard_title: "Панель управления",
        .dashboard_tasks: "Задачи",
        .dashboard_documents: "Документы",
        .dashboard_approval_documents: "Документы на согласовании",
        .dashboard_show_all: "Все →",
        .dashboard_yesterday_open: "Вчера открыто",
        .dashboard_open: "Открыто",
        .dashboard_completed: "Выполнено",
        .dashboard_cancelled: "Отменено",
        .dashboard_not_sent: "Не отправлено",
        .dashboard_pending: "Ожидание",
        .dashboard_invoice: "Счёт-фактура",
        .dashboard_contracts: "Договоры",
        .dashboard_acts: "Акты",
        .dashboard_others: "Другие",
        .dashboard_sent_total: "Отправлено на согласование",
        .dashboard_sent: "Отправлено",
        .dashboard_in_review: "На согласовании",
        .dashboard_in_progress: "В процессе",
        .dashboard_approved: "Согласовано",
        .dashboard_declined: "Отклонено",
        .dashboard_cancelled_short: "Отмена",
        .dashboard_expired: "Просрочено",

        // Profile
        .profile_title: "Профиль",
        .profile_personal_info: "Личные данные",
        .profile_notifications: "Уведомления",
        .profile_about: "О приложении",
        .profile_settings: "Настройки",
        .profile_privacy: "Политика конфиденциальности",
        .profile_language: "Язык",
        .profile_logout: "Выйти",
        .profile_delete_account: "Удалить аккаунт",
        .profile_logout_alert_title: "Выход",
        .profile_logout_alert_message: "Вы действительно хотите выйти из аккаунта?",
        .profile_delete_alert_title: "Удалить аккаунт",
        .profile_delete_alert_message: "Внимание! При удалении аккаунта все ваши данные будут безвозвратно потеряны.",
        .profile_phone: "Телефон",
        .profile_no_name: "Без имени",
        .profile_language_picker_title: "Выберите язык",
        .profile_language_picker_description: "Язык интерфейса приложения",

        // Partner
        .partner_title: "Партнёры",
        .partner_search_placeholder: "Поиск контрагентов",
        .partner_not_found: "Контрагенты не найдены",
        .partner_status_all: "Все",
        .partner_status_active: "Активные",
        .partner_status_inactive: "Неактивные",
        .partner_status_blocked: "Заблокированные",
        .partner_status_unknown: "Неизвестно",
        .partner_status_label: "Статус",
        .partner_inn: "ИНН",
        .partner_no_name: "Без имени",

        // Partner Detail
        .partner_detail_contracts: "Договоры",
        .partner_detail_contact_info: "Контактная информация",
        .partner_detail_brand: "Бренд",
        .partner_detail_no_brand: "Нет названия бренда",
        .partner_detail_balance: "Баланс",
        .partner_detail_description: "Описание",
        .partner_detail_contacts: "Контакты",
        .partner_detail_no_contacts: "Контактные данные отсутствуют",
        .partner_detail_no_contracts: "Договоров нет",
        .partner_detail_date_label: "Дата",
        .partner_detail_website: "Веб-сайт",

        // Contact Type
        .contact_phone: "Телефон",
        .contact_telegram: "Telegram",
        .contact_email: "Email",
        .contact_other: "Контакт",

        // Transaction Status
        .transaction_completed: "Завершено",
        .transaction_pending: "В процессе",
        .transaction_cancelled: "Отменено",
        .transaction_unknown: "Неизвестно",

        // Deal Detail
        .deal_detail_contract: "Договор",
        .deal_detail_number: "Номер",
        .deal_detail_date: "Дата",
        .deal_detail_partner: "Контрагент",
        .deal_detail_type: "Тип",
        .deal_detail_payment: "Оплата",
        .deal_detail_document: "Документ",
        .deal_detail_loading: "Загрузка...",
        .deal_detail_view_file: "Посмотреть файл",
        .deal_detail_share_save: "Поделиться / Сохранить",
        .deal_detail_file_error: "Ошибка",
        .deal_detail_file_not_loaded: "Файл не загружен",
        .deal_detail_error_prefix: "Ошибка",

        // Payment Detail
        .payment_detail_title: "Платёжное поручение",
        .payment_detail_main: "Основное",
        .payment_detail_doc_number: "Номер документа",
        .payment_detail_amount: "Сумма",
        .payment_detail_receiver: "Получатель",
        .payment_detail_stir: "ИНН",
        .payment_detail_date: "Дата",
        .payment_detail_status: "Статус",
        .payment_detail_details: "Детали",
        .payment_detail_contract_label: "Номер и дата договора",
        .payment_detail_id_label: "ID / ID платежа",
        .payment_detail_comment_label: "Назначение платежа",
        .payment_detail_sender_label: "Отправитель средств",
        .payment_detail_receiver_label: "Получатель средств",
        .payment_detail_stir_inn: "ИНН",
        .payment_detail_mfo: "МФО",
        .payment_detail_account: "Расчётный счёт",

        // Deal
        .deal_title: "Договор",
        .deal_not_found: "Договоры не найдены",
        .deal_partner_label: "Партнёр",
        .deal_status_label: "Статус",

        // Payment
        .payment_title: "Платежи",
        .payment_income: "↑ Приход",
        .payment_outcome: "↓ Расход",
        .payment_no_data: "Данные отсутствуют",
        .payment_unknown: "Неизвестно",
        .payment_inn: "ИНН",

        // Common UI
        .search_placeholder: "Поиск",
        .search_empty: "Ничего не найдено",

        // Errors
        .error_server: "Ошибка на сервере",
        .error_session_expired: "Сессия истекла. Войдите снова.",
        .error_no_internet: "Не удалось подключиться к сети. Проверьте Wi-Fi или мобильный интернет и повторите попытку",
        .error_data: "Ошибка данных",
        .error_invalid_url: "Неверный URL"
    ]

    private static let english: [LocalizedKey: String] = [
        // Common
        .common_cancel: "Cancel",
        .common_ok: "OK",
        .common_delete: "Delete",
        .common_save: "Save",
        .common_error: "Error",

        // Tab Bar
        .tab_dashboard: "Home",
        .tab_partner: "Partners",
        .tab_document: "Documents",
        .tab_deal: "Deals",
        .tab_payment: "Payments",

        // Documents
        .documents_title: "Documents",
        .documents_search: "Search by document number",
        .documents_outgoing: "Outgoing",
        .documents_incoming: "Incoming",
        .documents_count: "documents",
        .documents_count_short: "pcs",
        .documents_summa: "Amount",
        .documents_qos: "VAT",
        .documents_qos_total: "Total with VAT",
        .documents_sum: "UZS",
        .documents_from: "from",
        .documents_inn_label: "TIN",
        .documents_not_found: "No documents found",
        .documents_type_all: "All",
        .documents_type_invoices: "Invoices",
        .documents_type_acts: "Acts",
        .documents_type_contracts: "Contracts",
        .documents_type_waybill: "Waybill",
        .documents_type_empowerment: "Empowerment",
        .documents_type_verification_act: "Verification Act",
        .documents_type_free_form: "Free Form",
        .documents_type_internal: "Internal",
        .documents_status_draft: "Draft",
        .documents_status_accepted: "Accepted by client / partner",
        .documents_status_rejected: "Rejected",
        .documents_status_in_review: "In Review",
        .documents_status_cancelled: "Cancelled",
        .documents_status_unknown: "Unknown",
        .documents_status_unselected: "Not selected",

        // Login
        .login_username_title: "Login",
        .login_username_placeholder: "Enter login",
        .login_password_title: "Password",
        .login_password_placeholder: "*****",
        .login_button: "Sign In",

        // Dashboard
        .dashboard_title: "Dashboard",
        .dashboard_tasks: "Tasks",
        .dashboard_documents: "Documents",
        .dashboard_approval_documents: "Approval Documents",
        .dashboard_show_all: "All →",
        .dashboard_yesterday_open: "Yesterday Open",
        .dashboard_open: "Open",
        .dashboard_completed: "Completed",
        .dashboard_cancelled: "Cancelled",
        .dashboard_not_sent: "Not Sent for Approval",
        .dashboard_pending: "Pending",
        .dashboard_invoice: "Invoice",
        .dashboard_contracts: "Contracts",
        .dashboard_acts: "Acts",
        .dashboard_others: "Others",
        .dashboard_sent_total: "Sent for Approval",
        .dashboard_sent: "Sent",
        .dashboard_in_review: "In Review",
        .dashboard_in_progress: "In Progress",
        .dashboard_approved: "Approved",
        .dashboard_declined: "Declined",
        .dashboard_cancelled_short: "Cancel",
        .dashboard_expired: "Expired",

        // Profile
        .profile_title: "Profile",
        .profile_personal_info: "Personal Info",
        .profile_notifications: "Notifications",
        .profile_about: "About App",
        .profile_settings: "Settings",
        .profile_privacy: "Privacy Policy",
        .profile_language: "Language",
        .profile_logout: "Log Out",
        .profile_delete_account: "Delete Account",
        .profile_logout_alert_title: "Log Out",
        .profile_logout_alert_message: "Are you sure you want to log out?",
        .profile_delete_alert_title: "Delete Account",
        .profile_delete_alert_message: "Warning! Deleting your account will permanently remove all your data.",
        .profile_phone: "Phone",
        .profile_no_name: "No name",
        .profile_language_picker_title: "Choose Language",
        .profile_language_picker_description: "App interface language",

        // Partner
        .partner_title: "Partners",
        .partner_search_placeholder: "Search partners",
        .partner_not_found: "No partners found",
        .partner_status_all: "All",
        .partner_status_active: "Active",
        .partner_status_inactive: "Inactive",
        .partner_status_blocked: "Blocked",
        .partner_status_unknown: "Unknown",
        .partner_status_label: "Status",
        .partner_inn: "TIN",
        .partner_no_name: "No name",

        // Partner Detail
        .partner_detail_contracts: "Contracts",
        .partner_detail_contact_info: "Contact Info",
        .partner_detail_brand: "Brand",
        .partner_detail_no_brand: "No brand name",
        .partner_detail_balance: "Balance",
        .partner_detail_description: "Description",
        .partner_detail_contacts: "Contacts",
        .partner_detail_no_contacts: "No contact info",
        .partner_detail_no_contracts: "No contracts",
        .partner_detail_date_label: "Date",
        .partner_detail_website: "Website",

        // Contact Type
        .contact_phone: "Phone",
        .contact_telegram: "Telegram",
        .contact_email: "Email",
        .contact_other: "Contact",

        // Transaction Status
        .transaction_completed: "Completed",
        .transaction_pending: "Pending",
        .transaction_cancelled: "Cancelled",
        .transaction_unknown: "Unknown",

        // Deal Detail
        .deal_detail_contract: "Contract",
        .deal_detail_number: "Number",
        .deal_detail_date: "Date",
        .deal_detail_partner: "Partner",
        .deal_detail_type: "Type",
        .deal_detail_payment: "Payment",
        .deal_detail_document: "Document",
        .deal_detail_loading: "Loading...",
        .deal_detail_view_file: "View File",
        .deal_detail_share_save: "Share / Save",
        .deal_detail_file_error: "Error",
        .deal_detail_file_not_loaded: "File not loaded",
        .deal_detail_error_prefix: "Error",

        // Payment Detail
        .payment_detail_title: "Payment Order",
        .payment_detail_main: "Main",
        .payment_detail_doc_number: "Document Number",
        .payment_detail_amount: "Amount",
        .payment_detail_receiver: "Receiver",
        .payment_detail_stir: "TIN",
        .payment_detail_date: "Date",
        .payment_detail_status: "Status",
        .payment_detail_details: "Details",
        .payment_detail_contract_label: "Contract No. and Date",
        .payment_detail_id_label: "ID / Payment ID",
        .payment_detail_comment_label: "Payment Purpose",
        .payment_detail_sender_label: "Funds Sender",
        .payment_detail_receiver_label: "Funds Receiver",
        .payment_detail_stir_inn: "TIN",
        .payment_detail_mfo: "MFO",
        .payment_detail_account: "Account Number",

        // Deal
        .deal_title: "Deal",
        .deal_not_found: "No deals found",
        .deal_partner_label: "Partner",
        .deal_status_label: "Status",

        // Payment
        .payment_title: "Payments",
        .payment_income: "↑ Income",
        .payment_outcome: "↓ Outcome",
        .payment_no_data: "No data available",
        .payment_unknown: "Unknown",
        .payment_inn: "TIN",

        // Common UI
        .search_placeholder: "Search",
        .search_empty: "Nothing found",

        // Errors
        .error_server: "Server error occurred",
        .error_session_expired: "Session expired. Please log in again.",
        .error_no_internet: "Unable to connect to network. Check your Wi-Fi or mobile internet and try again",
        .error_data: "Data error",
        .error_invalid_url: "Invalid URL"
    ]
}
