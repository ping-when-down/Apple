//
//  WebsitesStorage.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import Foundation
import Combine

class PingWhenDownAPI: ObservableObject {
  
  /* * */
  /* MARK: - Settings */
  
  private var syncInterval = 10.0 // seconds
  private var endpoint = "https://pingwhendown-api.herokuapp.com"
  
  /* * */
  
  
  
  /* * */
  /* MARK: - Published Variables */
  
  @Published var websites: [Website] = []
  
  /* * */
  
  
  init() {
    self.getAllWebsites()
  }
  
  
  /* * */
  /* MARK: - State */
  
  
  /* * * *
   * STATE: ENUMERATION FOR STATE CONTROL
   * There are three possible states for vehicles storage.
   *  IDLE - Module is paused. Nothing is happening;
   *  SYNCING - Module fetches vehicle positions acording to the set syncInterval;
   *  ERROR - Module encountered an error while syncing.
   */
  enum State {
    case idle
    case active
    case loading
    case paused
    case error
  }
  
  
  /* * * *
   * STATE: STATE VARIABLE
   * This variable holds state. When it is changed, a set of operations are performed:
   *  IDLE - Timer is invalidated. Syncing is halted.
   *  SYNCING - Timer is set. Vehicle positions are continuosly fetched from API.
   *  ERROR - An error occured while syncing. Syncing is halted and timer is invalidated.
   */
  @Published var state: State = .paused {
    // We add a property observer on 'routeNumber', which lets us
    // run a function evertyime it's value changes.
    didSet {
      switch state {
        case .idle:
          break
        case .paused:
          break
        case .active:
          self.getAllWebsites()
          break
        case .loading:
          break
        case .error:
          break
      }
    }
  }

  
  /* * * *
   * STATE: SET (:State)
   * This function sets the state variable.
   */
  func set(state: State) {
    self.state = state
  }
  
  
  /* * * *
   * STATE: GET STATE
   * This function return the state variable.
   */
  func getState() -> State {
    return self.state
  }
  
  
  /* * * *
   * STATE: GET VEHICLES
   * This function calls the GeoBus API and receives vehicle metadata, including positions, for the set route number,
   * while storing them in the vehicles array. It also formats VehicleAnnotations and stores them in the annotations array.
   * It must have @objc flag because Timer is written in Objective-C.
   */
  func getAllWebsites() {
    
    self.set(state: .loading)
    
    // Setup the url
    let url = URL(string: endpoint + "/websites")!
    
    // Configure a session
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // Create the task
    let task = session.dataTask(with: url) { (data, response, error) in
      
      let httpResponse = response as? HTTPURLResponse
      
      // Check status of response
      if httpResponse?.statusCode != 200 {
        print("Error: API failed at getWebsites()")
        OperationQueue.main.addOperation { self.set(state: .error) }
        return
      }
      
      do {
        
        let decodedData = try JSONDecoder().decode([WebsiteModel].self, from: data!)
        
        OperationQueue.main.addOperation {
          
          self.websites.removeAll()
          
          for websiteModel in decodedData {
            self.websites.append(Website(properties: websiteModel))
          }
          
          self.websites.sort(by: { $1.properties.index > $0.properties.index })
          
          self.set(state: .idle)
          
        }
        
      } catch {
        print("Error info: \(error)")
        OperationQueue.main.addOperation { self.set(state: .error) }
      }
    }
    
    task.resume()
    
  }
  
  
  /* MARK: State - */
  /* * */
  
  
  
//  func add(website: Website) {
//
//    // Add localy
//    websites.append(website)
//    
//    // Add remotely
//    guard let encoded = try? JSONEncoder().encode(website) else {
//        print("Failed to encode order")
//        return
//    }
//
//    // create post request
//    var request = URLRequest(url: URL(string: endpoint + "/websites")!)
//    request.httpMethod = "POST"
//
//    // insert json data to the request
//    request.httpBody = encoded
//    
//    request.setValue("application/json", forHTTPHeaderField: "Accept")
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            
//            if let error = error {
//                print("Error took place \(error)")
//                return
//            }
//            guard let data = data else {return}
//            do{
//                let todoItemModel = try JSONDecoder().decode(Website.self, from: data)
//                print("Response data:\n \(todoItemModel)")
//                print("todoItemModel Title: \(todoItemModel.title)")
//                print("todoItemModel id: \(todoItemModel.url)")
//            }catch let jsonErr{
//                print(jsonErr)
//           }
//     
//    }
//    
//    task.resume()
//    
//  }
  
  
  
  
  
  
//  func delete(at offsets: IndexSet) {
//
//    // Delete remotely
//    var idsToDelete: [String] = []
//    offsets.forEach { index in
//      idsToDelete.append(websites[index].properties._id)
//    }
//
//    // Delete localy
//    websites.remove(atOffsets: offsets)
//
//    // Delete remotely
//    idsToDelete.forEach { id in
//
//      var request = URLRequest(url: URL(string: endpoint + "/websites/" + id)!)
//
//      request.httpMethod = "DELETE"
//      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//        if let error = error {
//          print("Error took place \(error)")
//          return
//        }
//      }
//
//      task.resume()
//
//    }
//
//  }

  
//  func reorder(from source: IndexSet, to destination: Int) {
//
//    websites.move(fromOffsets: source, toOffset: destination)
//
//    for (index, website) in websites.enumerated() {
//
//      websites[index].properties.index = index
//
//      guard let encoded = try? JSONEncoder().encode(websites[index]) else {
//          print("Failed to encode order")
//          return
//      }
//
//      // create post request
//      var request = URLRequest(url: URL(string: endpoint + "/websites/" + website.properties._id)!)
//      request.httpMethod = "PUT"
//
//      // insert json data to the request
//      request.httpBody = encoded
//      request.setValue("application/json", forHTTPHeaderField: "Accept")
//      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//
//              if let error = error {
//                  print("Error took place \(error)")
//                  return
//              }
//              guard let data = data else {return}
//              do{
//                  let todoItemModel = try JSONDecoder().decode(Website.self, from: data)
//                  print("Response data:\n \(todoItemModel)")
//                  print("todoItemModel Title: \(todoItemModel.title)")
//                  print("todoItemModel id: \(todoItemModel.url)")
//              }catch let jsonErr{
//                  print(jsonErr)
//             }
//
//      }
//
//      task.resume()
//
//    }
//
//  }
  
  
}
