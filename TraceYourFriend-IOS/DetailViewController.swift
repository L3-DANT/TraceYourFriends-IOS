//
//  DetailViewController.swift
//  TraceYourFriend-IOS
//
//  Created by Aniss on 12/05/2016.
//  Copyright © 2016 Aniss. All rights reserved.
//



import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    var detailUser: User? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let detailUser = detailUser {
            if let detailDescriptionLabel = detailDescriptionLabel {
                detailDescriptionLabel.text = "X : " + detailUser.coorX + " Y : " + detailUser.coorY
                title = detailUser.name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

