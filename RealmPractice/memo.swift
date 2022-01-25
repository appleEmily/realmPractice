//
//  memo.swift
//  RealmPractice
//
//  Created by Emily Nozaki on 2022/01/25.
//

import Foundation
import RealmSwift

class Memo: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
}
