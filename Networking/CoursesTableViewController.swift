//
//  CoursesTableViewController.swift
//  Networking
//
//  Created by Roman Oliinyk on 21.06.2020.
//  Copyright © 2020 Roman Oliinyk. All rights reserved.
//

import UIKit

class CoursesTableViewController: UITableViewController {
    
    private let url = "https://swiftbook.ru/wp-content/uploads/api/api_courses"
    private let postRequestURL = "https://jsonplaceholder.typicode.com/posts"
    
    var courses = [CourseData]()
    
    private var courseName: String?
    private var courseURL: String?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        fetchData()
//
//    }
    
    
    func fetchData() {
        NetworkManager.fetchCoursesData(url: url) { (courses) in
            self.courses = courses
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkRequest.sendRequest(url: url) { courses in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func postRequestAlamofire() {
        AlamofireNetworkRequest.postRequest(url: postRequestURL) { (courses) in
            self.courses = courses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return courses.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let course = courses[indexPath.row]
        
        cell.nameLabel?.text = course.name
        cell.numberOfLessons?.text = "Number of lessosns: \(course.number_of_lessons ?? 0)"
        cell.numberOfTests?.text = "Number of tests: \(course.number_of_tests ?? 0)"
        courseURL = course.link
        courseName = course.name
        
        
        DispatchQueue.global().async {
            guard let imageURL = URL(string: course.imageUrl!),
                  let imageData = try? Data(contentsOf: imageURL)
                else { return }
            
            DispatchQueue.main.async {
                cell.courseImageView.image = UIImage(data: imageData)
            }
        }
        
        return cell
    }
    
    
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //        let course = courses[indexPath.row]
    //
    //        performSegue(withIdentifier: "showWebView", sender: self)
    //
    //    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webView = segue.destination as! CourseWebViewController
        webView.courseName = courseName
        guard let url = URL(string: self.courseURL!) else { return }
        
        webView.url = url
        
        
        
    }
}
