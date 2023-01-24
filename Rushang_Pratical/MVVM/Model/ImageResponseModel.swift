//
//  ImageResponseModel.swift


import Foundation


// MARK: - GallaryData
struct GallaryData: Codable {
    let total, totalHits: Int?
    let images: [ImagesData]?
    
    enum CodingKeys: String, CodingKey {
        case total = "total"
        case totalHits = "totalHits"
        case images = "hits"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        totalHits = try values.decodeIfPresent(Int.self, forKey: .totalHits)
        images = try values.decodeIfPresent([ImagesData].self, forKey: .images)
    }
}

// MARK: - ImagesData
struct ImagesData: Codable {
    let id: Int?
    let pageURL: String?
    let type: String?
    let tags: String?
    let previewURL: String?
    let previewWidth, previewHeight: Int?
    let webformatURL: String?
    let webformatWidth, webformatHeight: Int?
    let largeImageURL: String?
    let imageWidth, imageHeight, imageSize, views: Int?
    let downloads, collections, likes, comments: Int?
    let userID: Int?
    let user: String?
    let userImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, collections, likes, comments
        case userID = "user_id"
        case user, userImageURL
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        pageURL = try values.decodeIfPresent(String.self, forKey: .pageURL)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        tags = try values.decodeIfPresent(String.self, forKey: .tags)
        previewURL = try values.decodeIfPresent(String.self, forKey: .previewURL)
        previewWidth = try values.decodeIfPresent(Int.self, forKey: .previewWidth)
        previewHeight = try values.decodeIfPresent(Int.self, forKey: .previewHeight)
        webformatHeight = try values.decodeIfPresent(Int.self, forKey: .webformatHeight)
        webformatURL = try values.decodeIfPresent(String.self, forKey: .webformatURL)
        webformatWidth = try values.decodeIfPresent(Int.self, forKey: .webformatWidth)
        largeImageURL = try values.decodeIfPresent(String.self, forKey: .largeImageURL)
        imageWidth = try values.decodeIfPresent(Int.self, forKey: .imageWidth)
        imageHeight = try values.decodeIfPresent(Int.self, forKey: .imageHeight)
        imageSize = try values.decodeIfPresent(Int.self, forKey: .imageSize)
        views = try values.decodeIfPresent(Int.self, forKey: .views)
        downloads = try values.decodeIfPresent(Int.self, forKey: .downloads)
        collections = try values.decodeIfPresent(Int.self, forKey: .collections)
        likes = try values.decodeIfPresent(Int.self, forKey: .likes)
        comments = try values.decodeIfPresent(Int.self, forKey: .comments)
        userID = try values.decodeIfPresent(Int.self, forKey: .userID)
        user = try values.decodeIfPresent(String.self, forKey: .user)
        userImageURL = try values.decodeIfPresent(String.self, forKey: .userImageURL)
    }
}
