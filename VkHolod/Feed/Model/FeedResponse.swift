import Foundation

struct FeedResponseWrapped: Decodable {
    let response : FeedResponse
}

struct FeedResponse: Decodable {
    var items : [FeedItem]
    var groups : [Group]
    var profiles : [Profile]
}

struct FeedItem: Decodable {
    let sourceId : Int
    let postId: Int?
    let text : String?
    let date : Double
    let comments : CountableItem?
    let likes : CountableItem?
    let reposts : CountableItem?
    let views : CountableItem?
    let attachments: [Attachment]?
}

struct Attachment: Decodable {
    let photo : Photo?
}

struct Photo: Decodable {
    
    var height : Int {
        return getSpecificSize().height
    }
    var width : Int {
        return getSpecificSize().width
    }
    var url : String {
        return getSpecificSize().url
    }
    let sizes : [PhotoSize]
    
    private func getSpecificSize() -> PhotoSize {
        if let specificSize = sizes.first(where: { $0.type == "x"}) {
            return specificSize
        } else if let fullBackSize = sizes.last {
            return fullBackSize
        } else {
            return PhotoSize(type: "OOpps", url: "Something went wrong", width: 0, height: 0)
        }
    }
}

struct PhotoSize : Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

struct CountableItem: Decodable {
    let count: Int
}

protocol ProfileRepresentable {
    var id: Int { get }
    var name: String { get }
    var photo: String { get }
}

struct Profile: Decodable, ProfileRepresentable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo100: String
    var name: String {
        return firstName + " " + lastName
    }
    var photo: String {
        return photo100
    }
}

struct Group: Decodable, ProfileRepresentable{
    let id: Int
    let name: String
    let photo100: String
    var photo: String {
        return photo100
    }
}
