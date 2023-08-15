// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum Alert {
    internal enum Authorization {
      /// Failed to log in
      internal static let message = L10n.tr("Localizable", "alert.authorization.message", fallback: "Failed to log in")
      /// Something went wrong :(
      internal static let title = L10n.tr("Localizable", "alert.authorization.title", fallback: "Something went wrong :(")
    }
  }
  internal enum Authorization {
    /// Demo
    internal static let demo = L10n.tr("Localizable", "authorization.demo", fallback: "Demo")
    /// Entrance
    internal static let enter = L10n.tr("Localizable", "authorization.enter", fallback: "Entrance")
    /// Enter
    internal static let entering = L10n.tr("Localizable", "authorization.entering", fallback: "Enter")
    /// Forgot your password?
    internal static let forgetPassword = L10n.tr("Localizable", "authorization.forgetPassword", fallback: "Forgot your password?")
    /// Password
    internal static let password = L10n.tr("Localizable", "authorization.password", fallback: "Password")
    /// Registration
    internal static let registrate = L10n.tr("Localizable", "authorization.registrate", fallback: "Registration")
    /// Register
    internal static let registration = L10n.tr("Localizable", "authorization.registration", fallback: "Register")
    internal enum Error {
      /// This username is busy
      internal static let loginIsBusy = L10n.tr("Localizable", "authorization.error.loginIsBusy", fallback: "This username is busy")
      /// Invalid username or password entered
      internal static let loginPasswordMistake = L10n.tr("Localizable", "authorization.error.loginPasswordMistake", fallback: "Invalid username or password entered")
      /// Enter email
      internal static let mailMistake = L10n.tr("Localizable", "authorization.error.mailMistake", fallback: "Enter email")
      /// The password must have at least 6 characters
      internal static let passwordMistake = L10n.tr("Localizable", "authorization.error.passwordMistake", fallback: "The password must have at least 6 characters")
    }
  }
  internal enum Basket {
    /// Cart
    internal static let title = L10n.tr("Localizable", "basket.title", fallback: "Cart")
  }
  internal enum Cart {
    internal enum MainScreen {
      /// Are you sure you want to delete an object from the cart?
      internal static let deleteItemAlert = L10n.tr("Localizable", "cart.mainScreen.deleteItemAlert", fallback: "Are you sure you want to delete an object from the cart?")
      /// Delete
      internal static let deleteItemButton = L10n.tr("Localizable", "cart.mainScreen.deleteItemButton", fallback: "Delete")
      /// The cart is empty
      internal static let emptyCart = L10n.tr("Localizable", "cart.mainScreen.emptyCart", fallback: "The cart is empty")
      /// Return
      internal static let returnButton = L10n.tr("Localizable", "cart.mainScreen.returnButton", fallback: "Return")
      /// To be paid
      internal static let toPayButton = L10n.tr("Localizable", "cart.mainScreen.toPayButton", fallback: "To be paid")
    }
    internal enum PayScreen {
      /// Pay
      internal static let payButton = L10n.tr("Localizable", "cart.payScreen.payButton", fallback: "Pay")
      /// Choose a payment method
      internal static let paymentChoice = L10n.tr("Localizable", "cart.payScreen.paymentChoice", fallback: "Choose a payment method")
      /// By making a purchase, you agree to the terms and conditions
      internal static let userTerms = L10n.tr("Localizable", "cart.payScreen.userTerms", fallback: "By making a purchase, you agree to the terms and conditions")
      /// User Agreement
      internal static let userTermsLink = L10n.tr("Localizable", "cart.payScreen.userTermsLink", fallback: "User Agreement")
    }
    internal enum SuccessfulPayment {
      /// Success! The payment has passed, congratulations on your purchase!
      internal static let successful = L10n.tr("Localizable", "cart.successfulPayment.successful", fallback: "Success! The payment has passed, congratulations on your purchase!")
      /// Return to the catalog
      internal static let toBackCatalogButton = L10n.tr("Localizable", "cart.successfulPayment.toBackCatalogButton", fallback: "Return to the catalog")
    }
    internal enum UnsuccessfulPayment {
      /// Try again
      internal static let tryAgain = L10n.tr("Localizable", "cart.unsuccessfulPayment.tryAgain", fallback: "Try again")
      /// Oops! Something went wrong :(
      /// Try again!
      internal static let unsuccessful = L10n.tr("Localizable", "cart.unsuccessfulPayment.unsuccessful", fallback: "Oops! Something went wrong :(\nTry again!")
    }
  }
  internal enum Catalog {
    /// Catalog
    internal static let title = L10n.tr("Localizable", "catalog.title", fallback: "Catalog")
    internal enum CurrentCollection {
      /// Author of the collection
      internal static let author = L10n.tr("Localizable", "catalog.currentCollection.author", fallback: "Author of the collection")
    }
    internal enum NftCard {
      internal enum Button {
        /// Add to Cart
        internal static let addToCart = L10n.tr("Localizable", "catalog.nftCard.button.addToCart", fallback: "Add to Cart")
        /// Go to the seller's website
        internal static let goToSellerSite = L10n.tr("Localizable", "catalog.nftCard.button.goToSellerSite", fallback: "Go to the seller's website")
        /// Remove from Cart
        internal static let removeFromCart = L10n.tr("Localizable", "catalog.nftCard.button.removeFromCart", fallback: "Remove from Cart")
      }
    }
  }
  internal enum General {
    /// Cancel
    internal static let cancel = L10n.tr("Localizable", "general.cancel", fallback: "Cancel")
    /// Close
    internal static let close = L10n.tr("Localizable", "general.close", fallback: "Close")
    /// Remove
    internal static let delete = L10n.tr("Localizable", "general.delete", fallback: "Remove")
    /// OK
    internal static let ok = L10n.tr("Localizable", "general.OK", fallback: "OK")
    /// Price
    internal static let price = L10n.tr("Localizable", "general.price", fallback: "Price")
    /// It seems that there is nothing
    /// pull down to update
    internal static let refreshStub = L10n.tr("Localizable", "general.refreshStub", fallback: "It seems that there is nothing\npull down to update")
    /// Return
    internal static let `return` = L10n.tr("Localizable", "general.return", fallback: "Return")
  }
  internal enum NetworkError {
    /// Data could not be retrieved
    internal static let anotherError = L10n.tr("Localizable", "networkError.anotherError", fallback: "Data could not be retrieved")
    /// Failed to convert the received data
    internal static let parsingError = L10n.tr("Localizable", "networkError.parsingError", fallback: "Failed to convert the received data")
    /// Request execution error
    internal static let requestError = L10n.tr("Localizable", "networkError.requestError", fallback: "Request execution error")
    /// Please try again later
    internal static let tryLater = L10n.tr("Localizable", "networkError.tryLater", fallback: "Please try again later")
    /// Check your internet connection
    internal static let urlSessionError = L10n.tr("Localizable", "networkError.URLSessionError", fallback: "Check your internet connection")
    internal enum Http {
      /// Nothing was found on the request
      internal static let _404 = L10n.tr("Localizable", "networkError.http.404", fallback: "Nothing was found on the request")
      /// Resource update error
      internal static let _409 = L10n.tr("Localizable", "networkError.http.409", fallback: "Resource update error")
      /// The requested resource is no longer available
      internal static let _410 = L10n.tr("Localizable", "networkError.http.410", fallback: "The requested resource is no longer available")
      /// Server-side error
      internal static let _5Хх = L10n.tr("Localizable", "networkError.http.5хх", fallback: "Server-side error")
    }
  }
  internal enum Onboarding {
    /// Collect
    internal static let collect = L10n.tr("Localizable", "onboarding.collect", fallback: "Collect")
    /// Compete
    internal static let competit = L10n.tr("Localizable", "onboarding.competit", fallback: "Compete")
    /// What's inside?
    internal static let isWhatInside = L10n.tr("Localizable", "onboarding.isWhatInside", fallback: "What's inside?")
    /// Explore
    internal static let research = L10n.tr("Localizable", "onboarding.research", fallback: "Explore")
    internal enum Collect {
      /// Replenish your collection with exclusive pictures created by the neural network!
      internal static let text = L10n.tr("Localizable", "onboarding.collect.text", fallback: "Replenish your collection with exclusive pictures created by the neural network!")
    }
    internal enum Competit {
      /// See the statistics of others and show everyone that you have the most valuable collection
      internal static let text = L10n.tr("Localizable", "onboarding.competit.text", fallback: "See the statistics of others and show everyone that you have the most valuable collection")
    }
    internal enum Research {
      /// Join us and discover a new world of unique NFT for collectors
      internal static let text = L10n.tr("Localizable", "onboarding.research.text", fallback: "Join us and discover a new world of unique NFT for collectors")
    }
  }
  internal enum Profile {
    /// Profile
    internal static let title = L10n.tr("Localizable", "profile.title", fallback: "Profile")
    internal enum EditScreen {
      /// Change photo
      internal static let changePhoto = L10n.tr("Localizable", "profile.editScreen.changePhoto", fallback: "Change photo")
      /// Description
      internal static let description = L10n.tr("Localizable", "profile.editScreen.description", fallback: "Description")
      /// Name
      internal static let name = L10n.tr("Localizable", "profile.editScreen.name", fallback: "Name")
      /// Website
      internal static let site = L10n.tr("Localizable", "profile.editScreen.site", fallback: "Website")
    }
    internal enum FavouritesNFT {
      /// You don't have any NFT favorites yet
      internal static let plug = L10n.tr("Localizable", "profile.favouritesNFT.plug", fallback: "You don't have any NFT favorites yet")
    }
    internal enum MainScreen {
      /// About developer
      internal static let aboutDeveloper = L10n.tr("Localizable", "profile.mainScreen.aboutDeveloper", fallback: "About developer")
      /// Favorites NFT
      internal static let favouritesNFT = L10n.tr("Localizable", "profile.mainScreen.favouritesNFT", fallback: "Favorites NFT")
      /// My NFT
      internal static let myNFT = L10n.tr("Localizable", "profile.mainScreen.myNFT", fallback: "My NFT")
    }
    internal enum MyNFT {
      /// From
      internal static let from = L10n.tr("Localizable", "profile.myNFT.from", fallback: "From")
      /// You don't have NFT yet
      internal static let plug = L10n.tr("Localizable", "profile.myNFT.plug", fallback: "You don't have NFT yet")
    }
  }
  internal enum Sorting {
    /// By name
    internal static let byName = L10n.tr("Localizable", "sorting.byName", fallback: "By name")
    /// By the number of NFT
    internal static let byNFTCount = L10n.tr("Localizable", "sorting.byNFTCount", fallback: "By the number of NFT")
    /// By price
    internal static let byPrice = L10n.tr("Localizable", "sorting.byPrice", fallback: "By price")
    /// By rating
    internal static let byRating = L10n.tr("Localizable", "sorting.byRating", fallback: "By rating")
    /// By title
    internal static let byTitle = L10n.tr("Localizable", "sorting.byTitle", fallback: "By title")
    /// Sorting
    internal static let title = L10n.tr("Localizable", "sorting.title", fallback: "Sorting")
  }
  internal enum Statistic {
    /// Statistics
    internal static let title = L10n.tr("Localizable", "statistic.title", fallback: "Statistics")
    internal enum Profile {
      internal enum ButtonCollection {
        /// NFT collection
        internal static let title = L10n.tr("Localizable", "statistic.profile.buttonCollection.title", fallback: "NFT collection")
      }
      internal enum ButtonUser {
        /// Go to the user's website
        internal static let title = L10n.tr("Localizable", "statistic.profile.buttonUser.title", fallback: "Go to the user's website")
      }
      internal enum UserCollection {
        /// The user does not have an NFT yet
        internal static let stub = L10n.tr("Localizable", "statistic.profile.userCollection.stub", fallback: "The user does not have an NFT yet")
      }
    }
  }
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
