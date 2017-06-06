//
//  Issue+IssueType.swift
//  Freetime
//
//  Created by Ryan Nystrom on 6/4/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
import IGListKit

extension IssueQuery.Data.Repository.Issue: IssueType {

    var pullRequest: Bool {
        return false
    }

    var labelableFields: LabelableFields {
        return fragments.labelableFields
    }

    var commentFields: CommentFields {
        return fragments.commentFields
    }

    var reactionFields: ReactionFields {
        return fragments.reactionFields
    }

    var closableFields: ClosableFields {
        return fragments.closableFields
    }

    func timelineViewModels(width: CGFloat) -> [IGListDiffable] {
        var results = [IGListDiffable]()

        for node in timeline.nodes ?? [] {
            guard let node = node else { continue }
            if let comment = node.asIssueComment {
                if let model = createCommentModel(
                    id: comment.id, 
                    commentFields: comment.fragments.commentFields,
                    reactionFields: comment.fragments.reactionFields,
                    width: width
                    ) {
                    results.append(model)
                }
            } else if let unlabeled = node.asUnlabeledEvent {
                let model = IssueLabeledModel(
                    id: unlabeled.id,
                    actor: unlabeled.actor?.login ?? Strings.unknown,
                    title: unlabeled.label.name,
                    color: unlabeled.label.color,
                    type: .removed
                )
                results.append(model)
            } else if let labeled = node.asLabeledEvent {
                let model = IssueLabeledModel(
                    id: labeled.id,
                    actor: labeled.actor?.login ?? Strings.unknown,
                    title: labeled.label.name,
                    color: labeled.label.color,
                    type: .added
                )
                results.append(model)
            }
        }

        return results
    }

}
