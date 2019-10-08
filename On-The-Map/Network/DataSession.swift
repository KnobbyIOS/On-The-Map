//
//  DataSession.swift
//  On-The-Map
//
//  Created by Brian Leding on 9/17/19.
//  Copyright © 2019 Brian Leding. All rights reserved.
//

import Foundation

class DataClient: NSObject {
    
    var session = URLSession.shared
    
    // authentication state
    var sessionID : String? = nil
    var userKey = "" //Cannot be String as used as String.type
    var userName = ""
    
    
    //Need to make this class a shared instance to be used in the login controller.
    class func sharedInstance() -> DataClient {
        struct SingletonClass {
            static var sharedInstance = DataClient()
        }
        return SingletonClass.sharedInstance
    }
    
    override init() {
        super.init()
    }
    
    func taskForGetMethod(_ method: String, parameters: [String:AnyObject], apiType: APIType = .udacityAPI, completionHandlerForGET: @escaping (_ result: Data?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, apiType: apiType))
        
        if apiType == .parseAPI {
            request.addValue(Constants.ParseParameterValues.parseID, forHTTPHeaderField: Constants.ParseParameterKeys.parseID)
            request.addValue(Constants.ParseParameterValues.restAPIKey, forHTTPHeaderField: Constants.ParseParameterKeys.restAPIKey)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var newData = data
            if apiType == APIType.udacityAPI {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
                
            }
            print(String(data: newData, encoding: .utf8)!)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            //self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            completionHandlerForGET(newData, nil)
        }
        
        task.resume()
        
        return task
    }
    
    func taskForPostMethod(_ method: String, parameters: [String:AnyObject], requestHeader : [String:AnyObject]? = nil, jsonBody: String, apiType: APIType = .udacityAPI, completionHandlerForPOST: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask{
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, apiType:  apiType))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        if let headerParameter = requestHeader {
            for(key, value) in headerParameter {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                print(response)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            // skipping the first 5 characters for Udacity API calls
            var newData = data
            if apiType == .udacityAPI {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            completionHandlerForPOST(newData as AnyObject, nil)
        }
        task.resume()
        return task
    }
    
    func taskForPutMethod(_ method: String, parameters: [String:AnyObject], requestHeader : [String:AnyObject]? = nil, jsonBody: String, apiType: APIType = .udacityAPI, completionHandlerForPUT: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask{
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, apiType:  apiType))
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        if let headerParameter = requestHeader {
            for(key, value) in headerParameter {
                request.addValue("\(value)", forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        task.resume()
        return task
    }
    
    func taskForDeleteMethod(_ method: String, parameters: [String:AnyObject], apiType: APIType = .udacityAPI, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        let request = NSMutableURLRequest(url: urlFromParameters(parameters, withPathExtension: method, apiType:  apiType))
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            var newData = data
            if apiType == .udacityAPI {
                let range = Range(5..<data.count)
                newData = data.subdata(in: range)
            }
            
            completionHandlerForDELETE(newData as AnyObject, nil)
        }
        
        task.resume()
        return task
    }
    
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    //To allow the swtich between the normal Udacity API and Parse API
    enum APIType {
        case udacityAPI
        case parseAPI
    }
    
    private func urlFromParameters(_ parameters:[String:AnyObject], withPathExtension: String? = nil, apiType: APIType = .udacityAPI) -> URL {
        
        var components = URLComponents()
        components.scheme = apiType == .udacityAPI ? Constants.Udacity.APIScheme : Constants.Parse.APIScheme
        //if the apiType is not the udacityAPI then use the Parse API
        components.host = apiType == .udacityAPI ? Constants.Udacity.APIHost : Constants.Parse.APIHost
        components.path = (apiType == .udacityAPI ? Constants.Udacity.APIPath : Constants.Parse.APIPath) + (withPathExtension ?? "")
        //components.queryItems = [URLQueryItem]()
        components.queryItems = nil
        
        var queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        
        if queryItems.count > 0 {
            
            components.queryItems = queryItems
        }
        
        return components.url!
        
        
    }

    func authenticateUser(username: String, password: String, completionHandlerForAuthentication: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let jsonBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        //Make the request
        _ = taskForPostMethod(Constants.UdacityMethods.SessionAuth, parameters: [:], jsonBody: jsonBody, completionHandlerForPOST: {(data, error) in
            
            if let error = error {
                print (data)
                print(error)
                completionHandlerForAuthentication(false, nil)
            } else {
                let userData = self.parseSessionData(data: data as? Data)
                if let sessionData = userData.0 {
                    guard let accountInfo = sessionData.account, accountInfo.registered == true else  {completionHandlerForAuthentication(false, "User not registered")
                        return
                    }
                    guard let sessionInfo = sessionData.session else {
                        completionHandlerForAuthentication(false, "No session data found")
                        return
                    }
                    self.userKey = accountInfo.key
                    self.sessionID = sessionInfo.id
                    completionHandlerForAuthentication(true, nil)
                } else {
                    completionHandlerForAuthentication(false, userData.1!.localizedDescription)
                    self.sessionID = nil
                }
            }
        })
    }
    
    /*func logoutUser(completionHandlerForLoggingOut: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        _ = taskForDeleteMethod(Constants.UdacityMethods.SessionAuth, parameters: [:], completionHandlerForDELETE: { (data, error) in
            if let error = error {
                print(error)
                completionHandlerForLoggingOut(false, error)
            } else {
                let sessionData = self.parseSessionData(data: data as? Data)
                if let _ = sessionData.0 {
                    self.userKey = ""
                    self.sessionID = ""
                    completionHandlerForLoggingOut(true, nil)
                } else {
                    completionHandlerForLoggingOut(false, sessionData.1!)
                }
            }
            
        })
        
    }*/
    
    func parseSessionData(data: Data?) -> (Constants.UserSession?, NSError?) {
        var locations: (userSession: Constants.UserSession?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let decoder = JSONDecoder()
                locations.userSession = try decoder.decode(Constants.UserSession.self, from: data)
            }
        } catch {
            print("Error parsing: \(error.localizedDescription)")
            let errorInfo = [NSLocalizedDescriptionKey: error]
            locations.error = NSError(domain: "parseSessionData", code: 1, userInfo: errorInfo)
        }
        return locations
    }
    
    func userInformation(completionHandler: @escaping (_ result: UserInformation?, _ error: NSError?) -> Void) {
        
        let url = Constants.UdacityMethods.Users + "/\(userKey)"
        
        _ = taskForGetMethod(url, parameters: [:], completionHandlerForGET: {(data, error) in
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                let response = self.parseStudentInformation(data: data)
                if let information = response.0 {
                    completionHandler(information, nil)
                } else {
                    completionHandler(nil, response.1)
                }
            }
        })
    }
    
    private func convertDataWithCompletionHandler(_ data : Data, completionHandlerForConvertingData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInformation = [NSLocalizedDescriptionKey : "Data could not be parsed: \(data)"]
            completionHandlerForConvertingData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInformation))
        }
        
        completionHandlerForConvertingData(parsedResult, nil)
        
    }
    
    //To fetch user location
    func studentsDetails(completionHandler: @escaping (_ result: [StudentDetails]?, _ error: NSError?) -> Void) {
        let parameters = [Constants.ParseParameterKeys.Order: "-updateAt" as AnyObject]
        _ = taskForGetMethod(Constants.ParseMethods.StudentLocation, parameters: parameters, apiType: .parseAPI) { (data, error) in
            //When called, all the below is skipped.
            if let error = error {
                print(error)
                completionHandler(nil, error)
            } else {
                if let data = data {
                    //let dict = data as? [AnyHashable:Any]
                    self.convertDataWithCompletionHandler(data, completionHandlerForConvertingData: { (parsedJson, error) in
                        var loggedInStudent = [StudentDetails]()
                        let dict =  parsedJson as? [AnyHashable:Any]
                        //Suggested refactor would not work as data would not accept index string.
                        //if let results = data[Constants.ParseJSONKeys.Results] as? [[String : AnyObject]] {
                        if let results = dict?[Constants.ParseJSONKeys.Results] as? [[String : AnyObject]] {
                            for info in results {
                                loggedInStudent.append(StudentDetails(info))
                            }
                            completionHandler(loggedInStudent, nil)
                            return
                        }
                        let loggedInUser = [NSLocalizedDescriptionKey: "Data could not be parsed"]
                        completionHandler(loggedInStudent, NSError(domain: "studentsDetails", code: 1, userInfo: loggedInUser))
                    })
                    
                }
            }
        }
    }
    
    //For Put method in MapPinView
    func updateUserLocation(newInformation: StudentDetails, completionHandler: @escaping (_ success: Bool, _ errpr: NSError?) -> Void) {
        
        let parameters =
            [Constants.ParseParameterKeys.restAPIKey : Constants.ParseParameterValues.restAPIKey,
             Constants.ParseParameterKeys.parseID : Constants.ParseParameterValues.parseID] as [String : AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(newInformation.studentKey)\", \"firstName\": \"\(newInformation.firstName)\", \"lastName\": \"\(newInformation.surname)\",\"mapString\": \"\(newInformation.mapString)\", \"mediaURL\": \"\(newInformation.mediaURL)\",\"latitude\": \(newInformation.latitude), \"longitude\": \(newInformation.longitude)}"
        
        let updateURL =  Constants.ParseMethods.StudentLocation + "/\(newInformation.locationID ?? "")"
        
        _ = taskForPutMethod(updateURL, parameters: parameters, jsonBody: jsonBody, completionHandlerForPUT: { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false, error)
            } else {
                
                var dataResponse: DataResponse!
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        dataResponse = try decoder.decode(DataResponse.self, from: data as! Data)
                        if let dataResponse = dataResponse, dataResponse.updateTime != nil {
                            completionHandler(true, nil)
                        }
                    }
                } catch {
                    let errorMessage = "Data could not be parsed \(error.localizedDescription)"
                    print(errorMessage)
                    let loggedInUser = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandler(false, NSError(domain: "updateUserLocation", code: 1, userInfo: loggedInUser))
                }
            }
        })
    }
    
    func postUserLocation(information: StudentDetails, completionHandler: @escaping (_ success: Bool, _ errpr: NSError?) -> Void) {
        
        let parameters =
            [Constants.ParseParameterKeys.restAPIKey : Constants.ParseParameterValues.restAPIKey,
             Constants.ParseParameterKeys.parseID : Constants.ParseParameterValues.parseID] as [String : AnyObject]
        
        let jsonBody = "{\"uniqueKey\": \"\(information.studentKey)\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.surname)\",\"mapString\": \"\(information.mapString)\", \"mediaURL\": \"\(information.mediaURL)\",\"latitude\": \(information.latitude), \"longitude\": \(information.longitude)}"
        
        _ = taskForPostMethod(Constants.ParseMethods.StudentLocation, parameters: [:], requestHeader: parameters, jsonBody: jsonBody, apiType: .parseAPI) { (data, error) in
            if let error = error {
                print(error)
                completionHandler(false, error)
            } else {
                
                var dataResponse: DataResponse!
                do {
                    if let data = data {
                        let decoder = JSONDecoder()
                        dataResponse = try decoder.decode(DataResponse.self, from: data as! Data)
                        if let dataResponse = dataResponse, dataResponse.createdAt != nil {
                            completionHandler(true, nil)
                        }
                    }
                } catch {
                    let errorMessage = "Data could not be parsed \(error.localizedDescription)"
                    print(errorMessage)
                    let loggedInUser = [NSLocalizedDescriptionKey : errorMessage]
                    completionHandler(false, NSError(domain: "updateUserLocation", code: 1, userInfo: loggedInUser))
                }
            }
        }
    }
    
    
    func parseStudentInformation(data: Data?) -> (UserInformation?, NSError?) {
        var dataResponse: (studentInfo: UserInformation?, error: NSError?) = (nil, nil)
        do {
            if let data = data {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                dataResponse.studentInfo = try jsonDecoder.decode(UserInformation.self, from: data)
            }
        } catch {
            print("Could not parse JSON data")
            let userInformation = [NSLocalizedDescriptionKey: error.localizedDescription]
            dataResponse.error = NSError(domain: "parseStudentInformation", code: 1, userInfo: userInformation)
        }
        return dataResponse
    }
}
