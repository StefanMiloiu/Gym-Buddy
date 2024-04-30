import Foundation

class Network {
    
     func fetchData(completion: @escaping (Data?) -> Void) {
        let headers = [
            "X-RapidAPI-Key": "280a717401msh430f5ad2fdd703dp118994jsnffbb227e333e",
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
    
    func decodeData() -> [ExerciseApi] {
        var exercises = [ExerciseApi]()
        let group = DispatchGroup()
        group.enter()
        
        fetchData { data in
            defer {
                group.leave()
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([ExerciseApi].self, from: data)
                exercises = decodedData
            } catch {
                print(error)
            }
        }
        
        group.wait()
        return exercises
    }
    
    //MARK: - Fetch Data Local
    func fetchDataLocal() -> [ExerciseApi] {
        var exercises = [ExerciseApi]()
        // Read data from the file
        if let fileURL = Bundle.main.url(forResource: "data", withExtension: "txt") {
            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                
                // Decode the JSON data
                exercises = try decoder.decode([ExerciseApi].self, from: data)
                return exercises
            } catch {
                print("Error reading or decoding data: \(error)")
            }
        } else {
            print("File 'data.txt' not found.")
        }
        return []
    }
}

