//
//  Website.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import Foundation
import Combine

class Website: ObservableObject, Identifiable {
  
  /* * */
  /* MARK: - Settings */
  
  private var updateInterval = 10.0 // seconds
  private var endpoint = "https://pingwhendown-api.herokuapp.com"
  
  let id = UUID()
  
  /* * */
  
  
  /* * */
  /* MARK: - Properties */
  
  @Published var properties: WebsiteModel
  
//  @Published var properties2: [String: Any]
  
  /* * */
  
  
  /* * */
  /* MARK: - Private Variables */
  
  private var timer: Timer? = nil
  
  /* * */
  
  
  init(properties: WebsiteModel) {
    self.properties = properties
    self.timer = Timer.scheduledTimer(
      timeInterval: updateInterval,
      target: self,
      selector: #selector(self.update),
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
          self.update()
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
   * STATE: UPDATE WEBSITE
   * This function calls the GeoBus API and receives vehicle metadata, including positions, for the set route number,
   * while storing them in the vehicles array. It also formats VehicleAnnotations and stores them in the annotations array.
   * It must have @objc flag because Timer is written in Objective-C.
   */
  @objc private func update() {
    // Setup the url
    let url = URL(string: endpoint + "/websites/" + (self.properties._id)! )!
    
    // Configure a session
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // Create the task
    let task = session.dataTask(with: url) { (data, response, error) in
      
      let httpResponse = response as? HTTPURLResponse
      
      // Check status of response
      if httpResponse?.statusCode != 200 {
        print("Error: API failed at getWebsites()")
        OperationQueue.main.addOperation { /* Propagate error here */ }
        return
      }
      
      do {
        
        let decodedData = try JSONDecoder().decode(WebsiteModel.self, from: data!)
        
        OperationQueue.main.addOperation {
          
          print(decodedData)
          
          self.properties = decodedData
        
        }
        
      } catch {
        print("Error info: \(error)")
        OperationQueue.main.addOperation { /* Propagate error here */ }
      }
    }
    
    task.resume()
  }
  
}
