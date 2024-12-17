//
//  ChatManager.swift
//  AppTest
//
//  Created by SR/DEV/L/295 on 26/11/24.
//

import StreamChat
import StreamChatUI
import Foundation
import UIKit

final class ChatManager {
    static let shared = ChatManager()
    private var client: ChatClient!
    private let tokens = [
        "test1":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdDEifQ.e5MENH1t7i8PsO5Ort4nfcqaN3rL5FgQZotFxhT_Z1M",
        "test2":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidGVzdDIifQ.SULBWNlPkQcoOuxEspag-5Y5IE6O5x6xKo9X3Re3W6c",
    ]
    func setup() {
        let client = ChatClient(config: .init(apiKey: .init("r4yhvxufn5zy")))
        self.client = client
    }

    // Authenticate

    func signIn(with username: String, completion: @escaping (Bool) -> Void) {
        guard !username.isEmpty else {
            completion(false)
            return
        }
        guard let token = tokens[username] else {
            completion(false)
            return
        }
        client.connectUser(
            userInfo: UserInfo(id: username, name: username),
            token: Token(stringLiteral: token)
        ) { error in
            completion(error == nil)
        }
    }

    func signOut() {
        client.disconnect()
        client.logout()
    }

    var isSignedIn: Bool {
        return client.currentUserId != nil
    }

    var currentUser: String? {
        return client.currentUserId
    }

    // Channels List + Creation

    public func createChannelList() -> UIViewController? {
        guard let id = currentUser else {
            return nil
        }
        let list = client.channelListController(query: .init(filter: .containMembers(userIds: [id])))
        let vc = ChatChannelListVC()
        vc.controller = list
        list.synchronize()
        return vc
    }

    public func createNewChannel(name: String
    ) {
        guard let current = currentUser else {
            return
        }
        let keys: [String] = tokens.keys.filter({ $0 != current }).map({ $0 })
        do {
            let result = try client.channelController(createChannelWithId: .init(type: .messaging, id: name),
                name: name,
                members: Set(keys),
                isCurrentUserMember: true
            )
            result.synchronize()
        } catch {
            print(error)
        }
    }


}
