//
//  UserDetailViewController.swift
//  Cards
//
//  Created by Divyesh Vekariya on 08/04/21.
//
import SwiftUI
import UIKit

class UserDetailViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var users = [UserInfo]()
    var startIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: "UserDetailCell", bundle: .main), forCellWithReuseIdentifier: "cell")

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.scrollToItem(at: IndexPath(item: startIndex, section: 0) , at: .centeredHorizontally, animated: true)
    }

}
extension UserDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
extension UserDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserDetailCell
        let user = users[indexPath.item]
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        cell.cityLabel.text = user.city
        cell.usernameLabel.text = user.username
        cell.phoneLabel.text = user.phone
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = .blue
        } else {
            cell.backgroundColor = .yellow
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    
}

struct UserDetailView: UIViewControllerRepresentable {
    let users:[UserInfo] , startPosithion:Int?
    
    func makeUIViewController(context: Context) -> UserDetailViewController {
        let vc = UserDetailViewController()
        vc.users = users
        vc.startIndex = startPosithion ?? 0
        return vc
        
    }
    
    func updateUIViewController(_ uiViewController: UserDetailViewController, context: Context) {
        uiViewController.collectionView.reloadData()
    }

}
