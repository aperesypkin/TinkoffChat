//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 24/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation
import MultipeerConnectivity

private extension String {
    static let serviceType = "tinkoff-chat"
    static let userNameKey = "userName"
    static let eventType = "TextMessage"
}

private extension TimeInterval {
    static let `default`: TimeInterval = 10
}

class MultipeerCommunicator: NSObject, ICommunicator {
    
    weak var delegate: ICommunicatorDelegate?
        
    private let localPeer = MCPeerID(displayName: UIDevice.current.identifierForVendor!.uuidString)
    
    private lazy var advertiser: MCNearbyServiceAdvertiser = {
        let userName: String
        if let users = try? AppUser.fetchUsers(context: CommonCoreDataStack.shared.mainContext), let name = users.first?.name {
            userName = name
        } else {
            userName = UIDevice.current.name
        }
        
        let advertiser = MCNearbyServiceAdvertiser(peer: localPeer, discoveryInfo: [.userNameKey: userName], serviceType: .serviceType)
        advertiser.delegate = self
        return advertiser
    }()
    
    private lazy var browser: MCNearbyServiceBrowser = {
        let browser = MCNearbyServiceBrowser(peer: localPeer, serviceType: .serviceType)
        browser.delegate = self
        return browser
    }()
    
    private var sessions: [MCPeerID: MCSession] = [:]
    
    private var messageID: String {
        return "\(arc4random_uniform(UInt32.max))\(Date.timeIntervalSinceReferenceDate)\(arc4random_uniform(UInt32.max))".data(using: .utf8)!.base64EncodedString()
    }
    
    private func obtainPeer(for userID: String) -> MCPeerID? {
        return sessions.keys.filter { $0.displayName == userID }.first
    }
    
    func start() {
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> Void)?) {
        guard let peer = obtainPeer(for: userID),
            let session = sessions[peer],
            let messageData = MultipeerMessage(eventType: .eventType, text: string, messageId: messageID).data else { return }
        do {
            try session.send(messageData, toPeers: [peer], with: .reliable)
            completionHandler?(true, nil)
        } catch {
            completionHandler?(false, error)
        }
    }
}

// MARK: - MCNearbyServiceAdvertiserDelegate
extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard let session = sessions[peerID] else { return }
        
        if session.connectedPeers.contains(peerID) {
            invitationHandler(false, nil)
        } else {
            invitationHandler(true, session)
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
}

// MARK: - MCNearbyServiceBrowserDelegate
extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        let session = MCSession(peer: localPeer, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessions[peerID] = session
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: .default)
        delegate?.didFoundUser(userID: peerID.displayName, userName: info?[.userNameKey])
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        let session = sessions.removeValue(forKey: peerID)
        session?.disconnect() //?
        delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error)
    }
}

// MARK: - MCSessionDelegate
extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = MultipeerMessage(data: data) else { return }
        delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
