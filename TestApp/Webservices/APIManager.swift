
import UIKit
import SystemConfiguration

enum DataFetchError: Error {
    case networkError
    case dataNotFound
    case authenticationError
}

@objc
@objcMembers class APIManager: NSObject {
    
    static let shared = APIManager()
    
    let constValueField = "application/json"
    let constHeaderField = "Content-Type"
    
    
    func get<T: Decodable>(apiUrl : String, completion: @escaping (Result<T, DataFetchError>) -> ()) {
        requestGetMethod(apiUrl: apiUrl, completion: completion)
    }
    
    func requestGetMethod<T: Decodable>(apiUrl : String, completion: @escaping (Result<T, DataFetchError>) -> ()) {
        
        if !APIManager().isConnectedToNetwork() {
            completion(.failure(.networkError))
        }
        
        let url = URL(string: apiUrl)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(.networkError))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch _ {
                completion(.failure(.dataNotFound))
            }
        }
        task.resume()
    }
    
    func requestPostWithImage(apiUrl : String, params: [String: AnyObject] ,imgUpload: UIImage, completion: @escaping (_ success: Bool, _ object: Data?) -> ()) {
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: URL(string: apiUrl)!)
//        if let strAuthToken = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.authToken) {
//            request.addValue("Bearer \(strAuthToken)", forHTTPHeaderField: "Authorization")
//        }
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let httpBody = NSMutableData()

        for (key, value) in params {
          httpBody.appendString(convertFormField(named: key, value: value, using: boundary))
        }

        httpBody.append(convertFileData(fieldName: "profile_pic",
                                        fileName: "imagename.png",
                                        mimeType: "image/png",
                                        fileData: imgUpload.pngData()!,
                                        using: boundary))

        httpBody.appendString("--\(boundary)--")
        print("Api start Call---\(Date())")
        request.httpBody = httpBody as Data
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with : request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                // check for fundamental networking error
                print("error=\(String(describing: error))")
                completion(true,nil)
                return
            }
            //var strJson = String(data: data, encoding: .utf8)
            completion(true,data)
        })
        task.resume()
        
        
        //completion(false, nil)
    }
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
      let data = NSMutableData()

      data.appendString("--\(boundary)\r\n")
      data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
      data.appendString("Content-Type: \(mimeType)\r\n\r\n")
      data.append(fileData)
      data.appendString("\r\n")

      return data as Data
    }
    
    func convertFormField(named name: String, value: AnyObject, using boundary: String) -> String {
      var fieldString = "--\(boundary)\r\n"
      fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
      fieldString += "\r\n"
      fieldString += "\(value)\r\n"

      return fieldString
    }
    
    func isConnectedToNetwork() -> Bool {
         
         var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
         zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
         zeroAddress.sin_family = sa_family_t(AF_INET)
         
         let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
              $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                   SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
              }
         }
         
         var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
         if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
              return false
         }
         
         /* Only Working for WIFI
          let isReachable = flags == .reachable
          let needsConnection = flags == .connectionRequired
          
          return isReachable && !needsConnection
          */
         
         // Working for Cellular and WIFI
         let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
         let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
         let ret = (isReachable && !needsConnection)
         
         return ret
         
    }
    
}
extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
