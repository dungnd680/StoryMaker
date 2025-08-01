//
//  InstagramSharingUtils.swift
//  StoryMaker
//
//  Created by Duyhung on 8/10/23.
//
//  https://codakuma.com/instagram-stories-sharing-swiftui/
//  https://dogusyigitozcelik.medium.com/sharing-feeds-and-stories-to-instagram-with-swift-6162a679d9ce
//  - https://github.com/dgsygtozcelik/InstaShare
//

import Foundation
import SwiftUI
import UIKit
import Photos

struct InstagramUtils {

    // Returns a URL if Instagram can be opened, otherwise returns nil.
    private static var instagramAppUrl: URL? {
        if let url = URL(string: "instagram://app") {
            if UIApplication.shared.canOpenURL(url) {
                return url
            }
        }
        return nil
    }

    private static var instagramStoriesUrl: URL? {
        if let url = URL(string: "instagram-stories://share?source_application=dungnd.StoryMaker") {
            if UIApplication.shared.canOpenURL(url) {
                return url
            }
        }
        return nil
    }

    static var canOpenInstagramApp: Bool {
        return instagramAppUrl != nil
    }

    static var canOpenInstagramStories: Bool {
        return instagramStoriesUrl != nil
    }

    // If Instagram Stories is available, writes the image to the pasteboard and then opens Instagram.
    static func sharePhotoAsStory(_ image: UIImage) {
        guard let instagramStoriesUrl = instagramStoriesUrl else {
            return
        }

        let imageDataOrNil = UIImage.pngData(image)
        guard let imageData = imageDataOrNil() else {
            return
        }

        let pasteboardItem = ["com.instagram.sharedSticker.backgroundImage": imageData]
        let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60 * 5)]

        UIPasteboard.general.setItems([pasteboardItem], options: pasteboardOptions)
        UIApplication.shared.open(instagramStoriesUrl, options: [:], completionHandler: nil)
    }

    // https://stackoverflow.com/a/73266996/2909384
    static func postImage(imagePath: URL, result: ((Bool) -> Void)? = nil) {
        guard let instagramURL = NSURL(string: "instagram://app") else {
            if let result = result {
                result(false)
            }
            return
        }

        do {
            try PHPhotoLibrary.shared().performChangesAndWait {
                let request = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: imagePath)!

                let assetID = request.placeholderForCreatedAsset?.localIdentifier ?? ""
                let shareURL = "instagram://library?LocalIdentifier=" + assetID

                if UIApplication.shared.canOpenURL(instagramURL as URL) {
                    if let urlForRedirect = NSURL(string: shareURL) {
                        UIApplication.shared.open(URL(string: "\(urlForRedirect)")!)
                    }
                }
            }
        } catch {
            if let result = result {
                result(false)
            }
        }
    }

}
