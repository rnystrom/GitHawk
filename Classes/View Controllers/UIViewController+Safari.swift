//
//  UIViewController+Safari.swift
//  Freetime
//
//  Created by Ryan Nystrom on 7/5/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {

    func presentSafari(url: URL) {
		guard let safariViewController = try? SFSafariViewController.configured(with: url) else { return }
		present(safariViewController, animated: trueUnlessReduceMotionEnabled)
    }

    func presentProfile(login: String) {
        present(CreateProfileViewController(login: login), animated: trueUnlessReduceMotionEnabled)
    }

    func presentCommit(owner: String, repo: String, hash: String) {
        guard let url = GithubClient.url(path: "\(owner)/\(repo)/commit/\(hash)") else { return }
        presentSafari(url: url)
    }

    func presentRelease(owner: String, repo: String, release: String) {
        guard let url = URL(string: "https://github.com/\(owner)/\(repo)/releases/tag/\(release)") else { return }
        presentSafari(url: url)
    }

    func presentLabels(owner: String, repo: String, label: String) {
        guard let url = GithubClient.url(path: "\(owner)/\(repo)/labels/\(label)") else { return }
        presentSafari(url: url)
    }

    func presentMilestone(owner: String, repo: String, milestone: Int) {
        guard let url = GithubClient.url(path: "\(owner)/\(repo)/milestone/\(milestone)") else { return }
        presentSafari(url: url)
    }

}

extension SFSafariViewController {

	static func configured(with url: URL) throws -> SFSafariViewController {
		let http = "http"
		let schemedURL: URL
		// handles http and https
		if url.scheme?.hasPrefix(http) == true {
			schemedURL = url
		} else {
			guard let u = URL(string: http + "://" + url.absoluteString) else { throw URL.Error.failedToCreateURL }
			schemedURL = u
		}
		let safariViewController = SFSafariViewController(url: schemedURL)
		safariViewController.preferredControlTintColor = Styles.Colors.Blue.medium.color
		return safariViewController
	}
}

extension URL {

	enum Error: Swift.Error {
		case failedToCreateURL
	}
}
