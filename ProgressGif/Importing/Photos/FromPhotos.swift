//
//  FromPhotos.swift
//  ProgressGif
//
//  Created by Zheng on 7/10/20.
//

import UIKit
import MobileCoreServices
import Photos
import SnapKit

// MARK: - Import via Photos

enum PhotoPermissionType {
    case askForAccess
    case goToSettings
    case dismiss
}

//MARK:- Image Picker
class FromPhotosPicker: UIViewController {
    
    @IBOutlet weak var referencePhotoPermissionsView: UIView!
    
    var shouldGoToSettings = false
    @IBOutlet var accessPermissionsView: UIView!
    @IBOutlet weak var accessPhotosGrantAccessButton: UIButton!
    @IBAction func grantAccessButtonPressed(_ sender: Any) {
        if shouldGoToSettings { /// user denied permission to photo library before, go to settings
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.6, animations: {
                            self.accessPermissionsView.alpha = 0
                        }) { _ in
                            self.accessPermissionsView.removeFromSuperview()
                            self.referencePhotoPermissionsView.isUserInteractionEnabled = false
                        }
                        self.collectionViewController?.getAssetFromPhoto()
                    }
                } else {
                    self.shouldGoToSettings = true
                    DispatchQueue.main.async {
                        self.accessPhotosGrantAccessButton.setTitle("Go to Settings", for: .normal)
                    }
                    
                }
            }
        }
    }
    
    var onDoneBlock: ((Bool) -> Void)? /// refresh the Gallery collection view once the user finished editing a gif
    
    var windowStatusBarHeight = CGFloat(0)
    
    /// the top blur header
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var xButton: UIButton!
    @IBAction func xButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var photosImageView: UIImageView!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var videosLabel: UILabel!
    
    private lazy var collectionViewController: CollectionViewController? = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            
            viewController.inset = CGFloat(4)
            viewController.topInset = visualEffectView.frame.height
            viewController.collectionType = .photos
            viewController.onDoneBlock = onDoneBlock
            viewController.displayPhotoPermissions = { [weak self] permissionType in
                if let selfU = self {
                    selfU.referencePhotoPermissionsView.isUserInteractionEnabled = true
                    selfU.referencePhotoPermissionsView.addSubview(selfU.accessPermissionsView)
                    selfU.accessPermissionsView.snp.makeConstraints { (make) in
                        make.edges.equalToSuperview()
                    }
                    
                    selfU.accessPhotosGrantAccessButton.layer.cornerRadius = 6
                    
                    switch permissionType {
                        
                    case .askForAccess:
                        selfU.shouldGoToSettings = false
                    case .goToSettings:
                        selfU.shouldGoToSettings = true
                        selfU.accessPhotosGrantAccessButton.setTitle("Go to Settings", for: .normal)
                    case .dismiss:
                        print("dismiss permission view")
                    }
                }
            }
            
            self.add(childViewController: viewController, inView: view)
            
            return viewController
        } else {
            return nil
        }
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        referencePhotoPermissionsView.isUserInteractionEnabled = false
        
        photosLabel.alpha = 0.7
        rightArrowImageView.alpha = 0.7
        
        _ = collectionViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            windowStatusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            windowStatusBarHeight = UIApplication.shared.statusBarFrame.height
            // Fallback on earlier versions
        }
        collectionViewController?.windowStatusBarHeight = self.windowStatusBarHeight
    }
}

