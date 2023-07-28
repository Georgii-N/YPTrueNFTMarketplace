// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Добавить в корзину
  internal static let addToBasket = L10n.tr("Localizable", "addToBasket", fallback: "Добавить в корзину")
  /// Корзина
  internal static let basket = L10n.tr("Localizable", "basket", fallback: "Корзина")
  /// По названию
  internal static let byName = L10n.tr("Localizable", "byName", fallback: "По названию")
  /// По количеству NFT
  internal static let byNFTCount = L10n.tr("Localizable", "byNFTCount", fallback: "По количеству NFT")
  /// Отменить
  internal static let cancel = L10n.tr("Localizable", "cancel", fallback: "Отменить")
  /// Каталог
  internal static let catalog = L10n.tr("Localizable", "catalog", fallback: "Каталог")
  /// Удалить
  internal static let delete = L10n.tr("Localizable", "delete", fallback: "Удалить")
  /// Цена
  internal static let price = L10n.tr("Localizable", "price", fallback: "Цена")
  /// Профиль
  internal static let profile = L10n.tr("Localizable", "profile", fallback: "Профиль")
  /// Вернуться
  internal static let `return` = L10n.tr("Localizable", "return", fallback: "Вернуться")
  /// Сортировка
  internal static let sorting = L10n.tr("Localizable", "sorting", fallback: "Сортировка")
  /// Статистика
  internal static let statistic = L10n.tr("Localizable", "statistic", fallback: "Статистика")
  /// К оплате
  internal static let toPay = L10n.tr("Localizable", "toPay", fallback: "К оплате")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
