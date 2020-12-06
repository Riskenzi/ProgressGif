//
//  FromFiles.swift
//  ProgressGif
//
//  Created by Zheng on 7/11/20.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

// MARK: - Import via Files
extension ViewController: DocumentDelegate {
    
    func didPickDocument(document: Document?) {
        if let pickedDoc = document {
            let fileURL = pickedDoc.fileURL
            saveDocument(temporaryDocumentURL: fileURL)
        }
    }
    
    func saveDocument(temporaryDocumentURL: URL) {
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyy"
        let dateAsString = formatter.string(from: date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HHmmss-SSSS"
        let timeAsString = timeFormatter.string(from: date)
        
        let timeName = "=\(dateAsString)=\(timeAsString)"
        let permanentFileURL = globalURL.appendingPathComponent(timeName).appendingPathExtension(temporaryDocumentURL.pathExtension)
        let permanentFileEnding = permanentFileURL.lastPathComponent
        
        DispatchQueue.global().async {
            
            do {
                let videoData = try Data(contentsOf: temporaryDocumentURL)
                try videoData.write(to: permanentFileURL, options: .atomic)
                
                DispatchQueue.main.async {
                    let avAsset = AVAsset(url: permanentFileURL)
                    
                    /// Make a new Project (Realm)
                    let newProject = Project()
                    newProject.title = "Untitled"
                    newProject.dateCreated = date
                    
                    let configuration = EditingConfiguration()
                    newProject.configuration = configuration
                    
                    let metadata = VideoMetadata()
                    newProject.metadata = metadata
                    
                    if let videoResolution = avAsset.resolutionSize() {
                        metadata.resolutionWidth = Int(videoResolution.width)
                        metadata.resolutionHeight = Int(videoResolution.height)
                    }
                    
                    let cmDuration = avAsset.duration
                    let duration = CMTimeGetSeconds(cmDuration)
                    metadata.duration = duration.getFormattedString() ?? "0:01"
                    
                    metadata.copiedFileIntoStorage = true
                    metadata.filePathEnding = permanentFileEnding
                    
                    do {
                        try self.realm.write {
                            self.realm.add(newProject)
                        }
                    } catch {
                        print("error adding object: \(error)")
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    if let viewController = storyboard.instantiateViewController(withIdentifier: "EditingViewController") as? EditingViewController {
                        
                        viewController.avAsset = avAsset
                        viewController.project = newProject
                        viewController.modalPresentationStyle = .fullScreen
                        
                        if #available(iOS 13.0, *) {
                            viewController.statusHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                        } else {
                            viewController.statusHeight = UIApplication.shared.statusBarFrame.height
                            // Fallback on earlier versions
                        }
                        
                        self.present(viewController, animated: true, completion: nil)
                        
                        permanentFileURL.generateImage { (generatedImage) in
                            if let image = generatedImage {
                                viewController.imageView.image = image
                            }
                            DispatchQueue.main.async {
                                viewController.setUpDrawing(with: viewController.editingConfiguration)
                            }
                        }
                        
                        viewController.onDoneBlock = { [weak self] _ in
                            self?.refreshCollectionViewInsert()
                        }
                    }
                }
            } catch {
                print("Error making video data: \(error)")
            }
        }
    }
}
