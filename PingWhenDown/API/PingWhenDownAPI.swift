//
//  WebsitesStorage.swift
//  PingWhenDown
//
//  Created by João de Vasconcelos on 18/08/2020.
//  Copyright © 2020 João de Vasconcelos. All rights reserved.
//

import Foundation
import Combine
import PushNotifications

class PingWhenDownAPI: ObservableObject {
  
  /* * */
  /* MARK: - Settings */
  
  private var syncInterval = 10.0 // seconds
  private var endpoint = "https://pingwhendown-api.herokuapp.com"
  
  private var timer: Timer? = nil
  
  let pushNotifications = PushNotifications.shared
  
  /* * */
  
  
  
  /* * */
  /* MARK: - Published Variables */
  
  @Published var websites: [Website] = []
  
  /* * */
  
  
  init() {
    self.sync()
    self.timer = Timer.scheduledTimer(
      timeInterval: syncInterval,
      target: self,
      selector: #selector(self.sync),
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
          self.sync()
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
  @objc func sync() {
    
    self.set(state: .loading)
    
    // Setup the url
    let url = URL(string: endpoint + "/websites")!
    
    // Configure a session
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // Create the task
    let task = session.dataTask(with: url) { (data, response, error) in
      
      let httpResponse = response as? HTTPURLResponse
      if httpResponse?.statusCode != 200 {
        print("Error: API failed at add(:Website)")
        OperationQueue.main.addOperation { self.set(state: .error) }
        return
      }
      
      do {
        
        let decodedData = try JSONDecoder().decode([Website].self, from: data!)
        
        OperationQueue.main.addOperation {
          
          if self.websites.count < 1 {
            
            self.websites.append(contentsOf: decodedData)
            
          } else {
            
            for item in decodedData {
              
              let i = self.websites.firstIndex { $0._id == item._id }
            
              self.websites[i!].title = item.title
              self.websites[i!].active = item.active
              self.websites[i!].index = item.index
              self.websites[i!].https = item.https
              self.websites[i!].host = item.host
              self.websites[i!].statusCode = item.statusCode
              self.websites[i!].statusMessage = item.statusMessage
              self.websites[i!].responseTime = item.responseTime
              self.websites[i!].lastChecked = item.lastChecked
              self.websites[i!].lastDown = item.lastDown
              
            }

          }
          
          self.websites.sort(by: { $1.index > $0.index })
          
          var notificationInterests: [String] = []
          for website in self.websites {
            notificationInterests.append(website.host)
          }
          try? self.pushNotifications.setDeviceInterests(interests: notificationInterests)
          
          
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
  
  
  
  func add(website: Website) {

    // Add localy
    websites.append(website)
    
    // Add remotely
    guard let requestBody = try? JSONEncoder().encode(website) else {
        print("Failed to encode order")
        return
    }

    // create post request
    var request = URLRequest(url: URL(string: endpoint + "/websites")!)
    
    request.httpMethod = "POST"
    request.httpBody = requestBody
    
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      
      let httpResponse = response as? HTTPURLResponse
      if httpResponse?.statusCode != 200 {
        print("Error: API failed at add(:Website)")
        OperationQueue.main.addOperation { self.set(state: .error) }
        return
      }
      
      do {
        
        let decodedData = try JSONDecoder().decode(Website.self, from: data!)
        
        OperationQueue.main.addOperation {
          let i = self.websites.firstIndex(of: website)
          self.websites[i!]._id = decodedData._id
        }
      
      } catch {
        print("Error info: \(error)")
        OperationQueue.main.addOperation { self.set(state: .error) }
      }
     
    }
    
    task.resume()
    
  }
  
  
  
  
  
  
  func delete(at offsets: IndexSet) {

    var idsToDelete: [String] = []
    offsets.forEach { index in
      idsToDelete.append(websites[index]._id!)
    }
    
    self.websites.remove(atOffsets: offsets)

    idsToDelete.forEach { id in

      var request = URLRequest(url: URL(string: endpoint + "/websites/" + id)!)
      request.httpMethod = "DELETE"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")

      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        let httpResponse = response as? HTTPURLResponse
        if httpResponse?.statusCode != 200 {
          print("Error: API failed at add(:Website)")
          OperationQueue.main.addOperation { self.set(state: .error) }
          return
        }
        
      }

      task.resume()

    }

  }
  
  
  

  
  func reorder(from source: IndexSet, to destination: Int) {

    websites.move(fromOffsets: source, toOffset: destination)

    for (index, website) in websites.enumerated() {

      websites[index].index = index

      guard let encoded = try? JSONEncoder().encode(websites[index]) else {
          print("Failed to encode order")
          return
      }

      // create post request
      var request = URLRequest(url: URL(string: endpoint + "/websites/" + website._id!)!)
      request.httpMethod = "PUT"

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
              }catch let jsonErr{
                  print(jsonErr)
             }

      }

      task.resume()

    }

  }
  
  
}
