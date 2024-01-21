//
//  ViewController.swift
//  PropertyWrapper
//
//  Created by Ibrahim Mo Gedami on 1/21/24.
//
import Combine
import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let jsonString = """
    {
      "userId": 1,
      "id": 1,
      "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
      "body": "quia et suscipit\\nsuscipit recusandae consequuntur expedita et cum\\nreprehenderit molestiae ut ut quas totam\\nnostrum rerum est autem sunt rem eveniet architecto",
      "posts": [],
      "details": { "id": 3 },
    }
    """
    
    private var cancellables: Set<AnyCancellable> = []
    private var posts: [Post] = []
    private var userId: Int?
    private var id: Int?
    private var titlee: String?
    private var body: String?
    private var jsonPosts: [Post]?
    private var details: JSONDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callApi()
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: AnyObject] {
                    // Now you have the parsed JSON as [String: AnyObject]
                    update(from: jsonObject)
                } else {
                    // Handle parsing error
                    print("Error: Parsed object is not a dictionary.")
                }
            } catch {
                // Handle JSONSerialization error
                print("Error during JSON serialization: \(error)")
            }
        } else {
            // Handle encoding error
            print("Error encoding JSON string to data.")
        }
        if let userId, let id, let titlee, let body, let details {
            print("userId: \(userId)\n\nId: \(id)\n\nTitle: \(titlee)\n\nBody:\(body)\n\nPosts: \(jsonPosts ?? [])\n\nDetails: \(details)")
        }
    }
    
    func callApi() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { receivedPosts in
                self.posts = receivedPosts
                self.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Title: \(posts[indexPath.row].title ?? "")"
        return cell
    }
    
    func update(from json: JSONDictionary?) {
        guard let content = json else { return }
        userId = JSONValueWrapper(from: content, forKey: Keys.userId).wrappedValue
        id = JSONValueWrapper(from: content, forKey: Keys.id).wrappedValue
        titlee = JSONValueWrapper(from: content, forKey: Keys.title).wrappedValue
        body = JSONValueWrapper(from: content, forKey: Keys.body).wrappedValue
        jsonPosts = JSONValueWrapper(from: content, forKey: Keys.jsonPosts).wrappedValue
        details = JSONValueWrapper(from: content, forKey: Keys.details).wrappedValue
    }
    
}
