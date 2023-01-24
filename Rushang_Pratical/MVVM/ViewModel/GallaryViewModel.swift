//
//  GallaryViewModel.swift


import Foundation

protocol GallaryViewModelDelegate:AnyObject {
    func didReceiveImagesResponse(serverResponse: GallaryData?,serverError: NetworkError?)
}


final class GallaryViewModel {
    var gallaryData:GallaryData?
    //Data Binding Clousure
    var eventHandler:((_ event:Event)->Void)?
    
    func fetchSearchedPhotos(searchText:String){
        let urlString = "\(API_BASE_URL)key=\(API_KEY)&q=\(searchText)&image_type=photo"
        self.eventHandler?(.loading)
        APIHandler.shared.getApiData(requestUrlStr: urlString, method: .get, resultType: GallaryData.self, completionHandler: { response in
            self.eventHandler?(.stoploading)
            switch response
            {
            case .success(let gallaryData):
                self.gallaryData = gallaryData
                self.eventHandler?(.dataLoaded)
            case .failure(let error):
                print(error.localizedDescription)
                self.eventHandler?(.error(error))
            }
        })
    }
}

extension GallaryViewModel {
    enum Event {
        case loading
        case stoploading
        case dataLoaded
        case error(Error?)
    }
}


//class GallaryViewModel {
//
//    weak var delegate : GallaryViewModelDelegate?
//
//    var httpClient:HttpUtility? = nil
//
//
//    init(_httpClient:HttpUtility) {
//        self.httpClient = _httpClient
//    }
//
//    func getListOfImages(searchText:String){
//        let url = "\(API_BASE_URL)key=\(API_KEY)&q=\(searchText)&image_type=photo"
//
//
//        self.httpClient?.getApiData(requestUrlStr: url, method: .get, resultType: GallaryData.self, completionHandler: { response in
//
//            switch response
//            {
//            case .success(let responseData):
//                print(responseData)
//            case .failure(let error):
//                print(error.localizedDescription)
//               // self.delegate?.didReceiveLoginResponse(loginResponse: false, errorResponse: NetworkError(errorMessage: error.localizedDescription))
//            }
//
//        })
//
//    }
//
//
//}
