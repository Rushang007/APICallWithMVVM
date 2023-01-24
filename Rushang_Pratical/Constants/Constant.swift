//
//  Constant.swift


import Foundation
import UIKit

let appDel = (UIApplication.shared.delegate as! AppDelegate)

let API_BASE_URL = "https://pixabay.com/api/?"
let API_KEY = "13197033-03eec42c293d2323112b4cca6"

struct StoryboardsName {
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

struct CellName {
    
    static let PhotosCell = "PhotosCell"
}

struct ValidationMessages {
    static let NoInternetConnection = "Please ensure you are connected to the internet and try again."
    static let SomethingWrongWithServer = "Something went wrong."
    static let WrongUrl = "Requested URL is not valid."
    static let ImageInput = "Input is required to search for photos"
   
}
