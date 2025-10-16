//
//  Recipe.swift
//  FridgeMate
//
// 菜谱数据模型：用于表示系统入门菜谱和用户自建菜谱。
// - 入门菜谱具有简介和图片（intro, imageName）
// - 用户自建菜谱只包含名称和食材列表

import Foundation

struct Recipe: Identifiable, Codable {
    let id: UUID = UUID()
    var name: String
    var ingredients: [String]
    var kind: Kind                 // .beginner 或 .user
    var intro: String?             // 仅入门菜谱使用
    var imageName: String?         // 仅入门菜谱使用

    enum Kind: String, Codable {
        case beginner
        case user
    }
}
