//
//  NetworkHelper.swift


import Foundation

enum DataError: Error {
    case invalidResponse
    case invalidURL
    case invalidData
    case network(Error?)
}

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


extension APIHandler {
    
    func request<T:Decodable>(url:String) async throws -> T {
        guard let url = URL(string: url) else {
            throw DataError.invalidURL
        }
        
        let (data,response) = try await URLSession.shared.data(from:url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    //How to Use request
    // @MainActor -> DispatchQueue.Main.async
//    @MainActor func fetchUsers() {
//        Task { // @MainActor in
//            do {
//                let userResponseArray: [UserModel] = try await manager.request(url: userURL)
//                    self.users = userResponseArray
//            }catch {
//                print(error)
//            }
//        }
//
//    }
    //------------------------- //------------------------- //-------------------------
    func postRequest<T: Encodable, R: Decodable>(url: String, body: T) async throws -> R {
        guard let url = URL(string: url) else {
            throw DataError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        let requestData = try encoder.encode(body)
        request.httpBody = requestData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        let decodedResponse = try decoder.decode(R.self, from: data)
        
        return decodedResponse
    }
    
    //How to Use postRequest
   
//    do {
//        let newUser = User(id: 1, name: "John Doe")
//        let createdUser: User = try await postRequest(url: "https://example.com/api/users", body: newUser)
//        print("User created:", createdUser)
//    } catch {
//        print("Error:", error)
//    }

}
