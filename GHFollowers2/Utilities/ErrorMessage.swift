//
//  ErrorMessage.swift
//  GHFollowers2
//
//  Created by Samet KATI on 18.05.2024.
//

import Foundation

enum GFError : String , Error {
    case invalidUsername = "This username created an invalid request.Please try again"
    case unableToComplate = "Unable to complete your request.Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid.Please try again."
    case unableToFavorites = "There was an error favoriting this user.Please try again"
    case alreadyInFavorite = "You've already favorited this user. You must REALLY like them!"
}
