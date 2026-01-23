import Foundation
import GRPC
import NIO
import SwiftProtobuf

/// A high-performance networking client for the Tinode backend.
/// Handles gRPC streaming, authentication, and packet routing.
final class TinodeClient {
    
    static let shared = TinodeClient()
    
    private var client: Pbx_NodeClient?
    private var call: BidirectionalStreamingCall<Pbx_ClientMsg, Pbx_ServerMsg>?
    private let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    
    private var messageIdCounter = 0
    var sessionToken: String?
    var myUserId: String?
    
    // Presence tracking: topic -> isOnline
    private var presenceState: [String: Bool] = [:]
    
    // Callbacks for data and presence
    var onData: ((Pbx_ServerData) -> Void)?
    var onPres: ((Pbx_ServerPres) -> Void)?
    var onCtrl: ((Pbx_ServerCtrl) -> Void)?
    var onMeta: ((Pbx_ServerMeta) -> Void)?
    var onInfo: ((Pbx_ServerInfo) -> Void)?
    
    // Search callback
    var onFindResult: (([Pbx_TopicSub]) -> Void)?
    
    private init() {}
    
    /// Connect to the Tinode gRPC endpoint.
    func connect(host: String = "localhost", port: Int = 16060) {
        let channel = ClientConnection
            .insecure(group: group)
            .connect(host: host, port: port)
        
        client = Pbx_NodeClient(channel: channel)
        
        // Start the message loop
        call = client?.messageLoop { [weak self] message in
            self?.handleIncoming(message)
        }
    }
    
    /// Send the initial Handshake message.
    func handshake(ua: String = "Pulse/1.0 (iOS)") {
        var hi = Pbx_ClientHi()
        hi.ver = "0.25"
        hi.userAgent = ua
        hi.lang = "en-US"
        hi.id = nextId()
        
        var msg = Pbx_ClientMsg()
        msg.hi = hi
        
        try? call?.sendMessage(msg).wait()
    }
    
    /// Authenticate using a session token or basic credentials.
    func login(scheme: String, secret: Data) {
        var login = Pbx_ClientLogin()
        login.scheme = scheme
        login.secret = secret
        login.id = nextId()
        
        var msg = Pbx_ClientMsg()
        msg.login = login
        
        try? call?.sendMessage(msg).wait()
    }
    
    /// Create a new account with basic authentication
    func createAccount(username: String, password: String, displayName: String) {
        var acc = Pbx_ClientAcc()
        acc.scheme = "basic"
        acc.secret = Data("\(username):\(password)".utf8)
        acc.login = true // Auto-login after creation
        acc.id = nextId()
        
        // Set display name in public data
        let publicData: [String: Any] = ["fn": displayName]
        if let jsonData = try? JSONSerialization.data(withJSONObject: publicData) {
            acc.desc.public = jsonData
        }
        
        var msg = Pbx_ClientMsg()
        msg.acc = acc
        
        try? call?.sendMessage(msg).wait()
    }
    
    /// Subscribe to a topic (e.g., 'me' or a group).
    func subscribe(to topic: String, withHistory: Bool = false) {
        var sub = Pbx_ClientSub()
        sub.topic = topic
        sub.id = nextId()
        
        // Request description and sub list by default
        var get = Pbx_GetQuery()
        if topic == "me" {
            get.what = "desc sub"
        } else if withHistory {
            // For chat topics, fetch recent history
            get.what = "desc data"
            get.data.limit = 20
        } else {
            get.what = "desc"
        }
        sub.getQuery = get
        
        var msg = Pbx_ClientMsg()
        msg.sub = sub
        
        try? call?.sendMessage(msg).wait()
    }
    
    /// Get message history for a topic
    func getHistory(topic: String, before seqId: Int32, limit: Int32 = 20) {
        var get = Pbx_ClientGet()
        get.topic = topic
        get.id = nextId()
        
        var query = Pbx_GetQuery()
        query.what = "data"
        query.data.limit = limit
        if seqId > 0 {
            query.data.beforeID = seqId
        }
        get.query = query
        
        var msg = Pbx_ClientMsg()
        msg.get = get
        
        try? call?.sendMessage(msg).wait()
    }
    
    /// Publish a message to a topic.
    func publish(text: String, to topic: String) {
        var pub = Pbx_ClientPub()
        pub.topic = topic
        pub.content = Data(text.utf8) // Simplified; Tinode usually expects JSON or Drafty
        pub.id = nextId()
        
        var msg = Pbx_ClientMsg()
        msg.pub = pub
        
        try? call?.sendMessage(msg).wait()
    }
    
    // MARK: - Private Helpers
    
    private func handleIncoming(_ message: Pbx_ServerMsg) {
        DispatchQueue.main.async {
            if let data = message.data {
                self.onData?(data)
            } else if let pres = message.pres {
                // Track presence state
                if pres.what == "on" {
                    self.presenceState[pres.topic] = true
                } else if pres.what == "off" {
                    self.presenceState[pres.topic] = false
                }
                self.onPres?(pres)
            } else if let meta = message.meta {
                if meta.topic == "fnd" {
                    self.onFindResult?(meta.sub)
                }
                self.onMeta?(meta)
            } else if let info = message.info {
                self.onInfo?(info)
            } else if let ctrl = message.ctrl {
                self.onCtrl?(ctrl)
                if ctrl.code == 200 {
                    if let token = ctrl.params["token"] {
                        self.sessionToken = String(data: token, encoding: .utf8)
                    }
                    if let user = ctrl.params["user"] {
                        self.myUserId = String(data: user, encoding: .utf8)
                    }
                }
            }
        }
    }
    
    /// Get presence state for a topic
    func getPresence(for topic: String) -> Bool {
        return presenceState[topic] ?? false
    }
    
    /// Send a note packet (for read receipts, typing indicators, etc.)
    func sendNote(topic: String, what: String, seqId: Int32 = 0) {
        var note = Pbx_ClientNote()
        note.topic = topic
        note.what = what
        if seqId > 0 {
            note.seqID = seqId
        }
        
        var msg = Pbx_ClientMsg()
        msg.note = note
        
        try? call?.sendMessage(msg).wait()
    }
    
    private func nextId() -> String {
        messageIdCounter += 1
        return "\(messageIdCounter)"
    }
    
    deinit {
        try? group.syncShutdownGracefully()
    }
}
