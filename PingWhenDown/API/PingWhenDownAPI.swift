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
  
  
  
  /* * */
  /* MARK: - Private Variables */
  
  private var timer: Timer? = nil
  
  /* * */
  
  
  
  
  init() {
    self.timer = Timer.scheduledTimer(
      timeInterval: syncInterval,
      target: self,
      selector: #selector(self.getWebsites),
      userInfo: nil,
      repeats: true
    )
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
          self.getWebsites()
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
  @objc private func getWebsites() {
    
    if (state == .paused) { return }
    
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
        
        let decodedData = try JSONDecoder().decode([Website].self, from: data!)
        
        OperationQueue.main.addOperation {
          
          self.websites.removeAll()
          
          for item in decodedData {
            self.websites.append(item)
          }
          
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
  
  
  
  func addWebsite(data: Website) {

    guard let encoded = try? JSONEncoder().encode(data) else {
        print("Failed to encode order")
        return
    }
    
    print(encoded)

    // create post request
    var request = URLRequest(url: URL(string: endpoint + "/websites")!)
    request.httpMethod = "POST"

    // insert json data to the request
    request.httpBody = encoded
    
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{
                let todoItemModel = try JSONDecoder().decode(Website.self, from: data)
                print("Response data:\n \(todoItemModel)")
                print("todoItemModel Title: \(todoItemModel.title)")
                print("todoItemModel id: \(todoItemModel.url)")
            }catch let jsonErr{
                print(jsonErr)
           }
     
    }
    task.resume()
  }
  
  
}
