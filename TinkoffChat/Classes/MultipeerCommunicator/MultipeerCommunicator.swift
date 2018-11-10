//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 24/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol CommunicatorDelegate: class {
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> Void)?)
    var delegate: CommunicatorDelegate? { get set }
    var online: Bool { get set }
}

private extension String {
    static let serviceType = "tinkoff-chat"
    static let userID = UUID().uuidString
    static let userNameKey = "userName"
    static let eventType = "TextMessage"
}

private extension TimeInterval {
    static let `default`: TimeInterval = 10
}

class MultipeerCommunicator: NSObject, Communicator {
    
    weak var delegate: CommunicatorDelegate?
    var online: Bool = true {
        didSet {
            online ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        }
    }
    
    private let localPeer = MCPeerID(displayName: .userID)
    
    private lazy var advertiser: MCNearbyServiceAdvertiser = {
        let advertiser = MCNearbyServiceAdvertiser(peer: localPeer, discoveryInfo: [.userNameKey: "Alexander"], serviceType: .serviceType)
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
    
    override init() {
        super.init()
        
        online ? advertiser.startAdvertisingPeer() : advertiser.stopAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    private func obtainPeer(for userID: String) -> MCPeerID? {
        return sessions.keys.filter { $0.displayName == userID }.first
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
        delegate?.failedToStartAdvertising(error: error)
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
        delegate?.failedToStartBrowsingForUsers(error: error)
    }
}

// MARK: - MCSessionDelegate
extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = MultipeerMessage(data: data) else { return }
        delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: localPeer.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}

struct MultipeerMessage: Codable {
    let eventType: String
    let text: String
    let messageId: String
    
    var data: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init(eventType: String, text: String, messageId: String) {
        self.eventType = eventType
        self.text = text
        self.messageId = messageId
    }
    
    init?(data: Data) {
        if let newValue = try? JSONDecoder().decode(MultipeerMessage.self, from: data) {
            self = newValue
        } else {
            return nil
        }
    }
}
