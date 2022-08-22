//
//  FlickrImageDetailViewController.swift
//  CVSCodingChallenge
//
//  Created by Brandon Riehle on 8/18/22.
//

import UIKit
import WebKit

class FlickrImageDetailViewController: UITableViewController {

    let section = Section(type: .Main, rows: [.Image, .Author, .DateTaken, .DatePublished])
    
    var webView: WKWebView!
    var flickrImage: FlickrImage!
    
    private var author = ""
    private var width = ""
    private var height = ""
    
    @MainActor private func updateImageInfo(_ author: String,_ width: String,_ height: String) {
        self.author = author
        self.width = width
        self.height = height
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = flickrImage.title
        
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.loadHTMLString(flickrImage.description, baseURL: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch section.rows[indexPath.row] {

        case .Image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageCell
            cell.configure(with: flickrImage.image)
            return cell

        case .Author:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath)
            cell.textLabel?.text = "Author: "
            cell.detailTextLabel?.text = author
            return cell

        case .DateTaken:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateTakenCell", for: indexPath)
            cell.textLabel?.text = "Date Taken:"
            cell.detailTextLabel?.text = formatDate(flickrImage.dateTaken)
            return cell

        case .DatePublished:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePublishedCell", for: indexPath)
            cell.textLabel?.text = "Date Published:"
            cell.detailTextLabel?.text = formatDate(flickrImage.published)
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch section.rows[indexPath.row] {
        case .Image:
            return 400
            
        default:
            return UITableView.automaticDimension
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
        return dateFormatter.string(from: date)
    }
}

extension FlickrImageDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        Task {
            let authorJS = "document.getElementsByTagName(\"a\")[0].innerHTML"
            let widthJS = "document.getElementsByTagName(\"img\")[0].width"
            let heightJS = "document.getElementsByTagName(\"img\")[0].height"

            do {
                let author = try await String(describing: webView.evaluateJavaScript(authorJS))
                let width = try await String(describing: webView.evaluateJavaScript(widthJS))
                let height = try await String(describing: webView.evaluateJavaScript(heightJS))
     
                updateImageInfo(author, width, height)
                
            } catch let error {
                print(error)
            }
        }
    }
}

extension FlickrImageDetailViewController {
    struct Section {
        var type: SectionType
        var rows: [RowItem]
    }
    
    enum SectionType {
        case Main
    }
    
    enum RowItem {
        case Image
        case Author
        case DateTaken
        case DatePublished
    }
}
