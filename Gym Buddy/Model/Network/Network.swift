import Foundation

class Network {
    
    private func fetchData(completion: @escaping (Data?) -> Void) {
        let headers = [
            "X-RapidAPI-Key": "58c36e58bfmsh66cfb5ac72e4288p1e3630jsn187186ba4f1c",
            "X-RapidAPI-Host": "exercisedb.p.rapidapi.com"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://exercisedb.p.rapidapi.com/exercises?limit=-1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil)
            } else {
                completion(data)
            }
        }
        dataTask.resume()
    }
    
    func decodeData() -> [Exercise] {
        var exercises = [Exercise]()
        let group = DispatchGroup()
        group.enter()
        
        fetchData { data in
            defer {
                group.leave()
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([Exercise].self, from: data)
                exercises = decodedData
                
            } catch {
                print(error)
            }
        }
        
        group.wait()
        return exercises
    }
}

