//
//  NetworkHelper.swift


import Foundation


final class APIHandler {
    static let shared = APIHandler()
    private init(){}
    
    func getApiData<T:Decodable>(requestUrlStr:String,method:HttpMethods,resultType: T.Type,completionHandler:@escaping(Result<T?, NetworkError>) -> Void)
    {
        guard let requestUrl = URL(string: requestUrlStr) else
        {
            completionHandler(.failure(NetworkError(errorMessage: ValidationMessages.WrongUrl, forStatusCode: nil)))
            return
        }
        if !InternetConnectionManager.isConnectedToNetwork(){
            completionHandler(.failure(NetworkError(errorMessage: ValidationMessages.NoInternetConnection, forStatusCode: nil)))
        }
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = method.rawValue
     
        self.performOperation(requestUrl: urlRequest, responseType: resultType) { (response) in
            completionHandler(response)
        }
    }
    
    
    // MARK: - Perform data task
     func performOperation<T: Decodable>(requestUrl: URLRequest, responseType: T.Type, completionHandler:@escaping(Result<T?, NetworkError>) -> Void)
    {
        URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in

            let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode ?? 404
            print("URL :: \(requestUrl)")
            print("ERROR :: \(error?.localizedDescription ?? "")")
            print("statusCode :: \(statusCode)")
            if responseData != nil {
                let responseJSON = try? JSONSerialization.jsonObject(with: responseData!, options: [])
                print("responseJSON :: \(responseJSON)")
            }
           
            switch statusCode
            {
            case 200..<300:
                if let response = self.decodeJsonResponse(data: responseData!, responseType: responseType)
                {
                    print("DecodeJsonResponse :: \(response)")
                    completionHandler(.success(response))
                }
                else
                {
                    completionHandler(.failure(NetworkError(errorMessage: error.debugDescription, forStatusCode: statusCode)))
                }
            case 403:
                break

            case 405:
                completionHandler(.failure( NetworkError(errorMessage: ValidationMessages.WrongUrl, forStatusCode: statusCode)))
            default:
                completionHandler(.failure(NetworkError(errorMessage: ValidationMessages.SomethingWrongWithServer, forStatusCode: statusCode)))
                break
            }
        }.resume()
    }
    
    private func decodeJsonResponse<T: Decodable>(data: Data, responseType: T.Type) -> T?
    {
        
        do {
            return try JSONDecoder().decode(responseType, from: data)
        }catch let error {
            debugPrint("error while decoding JSON response =>\(error.localizedDescription)")
        }
        return nil
    }
}
