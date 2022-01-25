//
//  ViewController.swift
//  RealmPractice
//
//  Created by Emily Nozaki on 2022/01/25.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITextFieldDelegate {
    
    //realmを使えるようにする
    let realm = try! Realm()

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //テキストフィールドのデリゲート処理はself。つまりこのViewControllerに書くよ！っていうこと
        titleText.delegate = self
        contentText.delegate = self
        
        //readメソッドで?をつけたことで、初めてアプリを開いたりでrealm内が空っぽな時も使えるようにした！
        //realmに入っているデータをreadメソッドで取り出して、それをmemoにセット！
        let memo: Memo? = read()
        if memo != nil {
            //nilの可能性を考慮してOpitional Chainingで処理している！
            titleText.text = memo?.title
            contentText.text = memo?.content
        }
        
        
    }
    //realmにアクセスして、メモの情報を読み出す。readっていうメソッド
    //返り値にnilがある可能性があるから、Memoの後に?をつけた
    func read() -> Memo? {
        return realm.objects(Memo.self).first
    }
    
    
    @IBAction func save() {
        let title: String =  titleText.text!
        let content: String = contentText.text!
        //今あるrealmに保存されているMemoを取り出す。あったら更新。ないなら生成をするための準備
        let memo: Memo? = read()
        if memo != nil {
            /*もう保存するテーブルが既にあるので、保存すなわち上書きすれば良い
             try! realm.writeで書き込み*/
            
            try! realm.write {
                //memoはnilではないので、memoを強制unwrapして、内容をセット。
                memo!.title = title
                memo!.content = content
            }
        } else {
            /*newMemoっていう今から保存するメモのインスタンスを生成。
             newMemoに色々追加。writeの塊で書き込むよ！って言う。
             新しいのでrealm.add()する！*/
            let newMemo = Memo()
            newMemo.title = title
            newMemo.content = content
            
            try! realm.write {
                realm.add(newMemo)
            }
            
        }
        //アラートを出すよ！
        //actionSheetは下から出るやつ
        //alertは普通に真ん中に出るやつ
        let alert: UIAlertController = UIAlertController(title: "成功", message: "保存しました", preferredStyle: .alert)
        /*stlyleをcancelにすると、枠外をさわった時に消える。
        destructiveはなんか文字赤くなった
         細かいのはメモに残したよ*/
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //alertを実行するためのコード
        present(alert, animated: true, completion: nil)
    }
    //キーボードを閉じるようにするよ
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }

}

