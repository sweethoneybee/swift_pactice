//
//  HomeViewController.swift
//  NetworkPractice
//
//  Created by 정성훈 on 2021/04/02.
//

import UIKit

class HomeViewController: UIViewController {
    private struct StoryBoard {
        static let ShowArticleList = "Show ArticleList"
        static let ShowArticleListTableView = "Show ArticleListTableView"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case StoryBoard.ShowArticleList:
            print("뉴스타이틀 세그웨이")
        case StoryBoard.ShowArticleListTableView:
            print("테이블뷰 세그웨이")
        default:
            ()
        }
    }
}
