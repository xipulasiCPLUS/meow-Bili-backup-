//
//  ArticleView.swift
//  DarockBili Watch App
//
//  Created by WindowsMEMZ on 2023/7/1.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the MeowBili open source project
//
// Copyright (c) 2023 Darock Studio and the MeowBili project authors
// Licensed under GNU General Public License v3
//
// See https://darock.top/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import SwiftUI
import DarockKit
import SwiftSoup

struct ArticleView: View {
    var cvid: String
    var body: some View {
        ScrollView {
            
        }
        .onAppear {
            DarockKit.Network.shared.requestString("https://www.bilibili.com/read/cv\(cvid)") { respStr, isSuccess in
                if isSuccess {
                    let doc: Document = try! SwiftSoup.parse(respStr)
                    debugPrint(try! doc.text())
                }
            }
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(cvid: "24554473")
    }
}
