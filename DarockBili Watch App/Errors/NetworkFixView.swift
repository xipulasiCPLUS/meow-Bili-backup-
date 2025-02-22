//
//  NetworkFixView.swift
//  DarockBili Watch App
//
//  Created by WindowsMEMZ on 2023/7/4.
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
import Foundation

struct NetworkFixView: View {
    @State var progressTimer: Timer?
    @State var networkState = 0
    @State var darockAPIState = 0
    @State var bilibiliAPIState = 0
    @State var isTroubleshooting = false
    // 0 尚未检查
    // 1 正在检查
    // 2 不可用
    // 3 可用
    // 4 无效返回
    var lightColors: [Color] = [.secondary, .orange, .red, .green, .red]
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if !isTroubleshooting {
                        if networkState == 3 && darockAPIState == 3 && bilibiliAPIState == 3 {
                            HStack {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.green)
                                Text("一切正常")
                                    .bold()
                            }
                            NavigationLink(destination: {FeedbackView()}, label: {
                                VStack {
                                    Text("仍有问题？")
                                    Text("提交反馈")
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                            })
                        } else {
                            Text("找到了以下问题：")
                                .bold()
                            if networkState == 2 {
                                NavigationLink(destination: {networkProblemDetailsView()}, label: {
                                    Text("无法连接到网络")
                                })
                            }
                            if darockAPIState == 2 || darockAPIState == 4 {
                                NavigationLink(destination: {darockAPIProblemDetailsView()}, label: {
                                    Text(darockAPIState == 2 ? "Darock API 无法访问" : "Darock API 响应无效")
                                })
                            }
                            if bilibiliAPIState == 2 {
                                NavigationLink(destination: {bilibiliAPIProblemDetailsView()}, label: {
                                    Text("Bilibili API 无法访问")
                                })
                            }
                        }
                    } else {
                        Text("正在检查...")
                            .bold()
                    }
                } footer: {
                    if !(networkState == 3 && darockAPIState == 3 && bilibiliAPIState == 3) {
                        Text("轻点问题以查看详细信息") //轻点问题以查看详细信息
                    }
                }
                Section("连接状态") {
                    HStack {
                        Circle()
                            .frame(width: 10)
                            .foregroundStyle(lightColors[networkState])
                            .padding(.trailing, 7)
                        if networkState == 0 {
                            Text("以太网")
                        } else if networkState == 1 {
                            Text("以太网：正在检查")
                        } else if networkState == 2 {
                            Text("以太网：离线")
                        } else if networkState == 3 {
                            Text("以太网：在线")
                        }
                        Spacer()
                    }
                    .padding()
                    HStack {
                        Circle()
                            .frame(width: 10)
                            .foregroundStyle(lightColors[darockAPIState])
                            .padding(.trailing, 7)
                        if darockAPIState == 0 {
                            Text("Darock API")
                                .foregroundStyle(networkState != 3 ? Color.secondary : .primary)
                        } else if darockAPIState == 1 {
                            Text("Darock API：正在检查")
                        } else if darockAPIState == 2 {
                            Text("Darock API：不可用")
                        } else if darockAPIState == 3 {
                            Text("Darock API：可用")
                        } else if darockAPIState == 4 {
                            Text("Darock API：无效响应")
                        }
                        Spacer()
                    }
                    .disabled(networkState != 3)
                    .padding()
                    HStack {
                        Circle()
                            .frame(width: 10)
                            .foregroundStyle(lightColors[bilibiliAPIState])
                            .padding(.trailing, 7)
                        if bilibiliAPIState == 0 {
                            Text("Bilibili API：")
                                .foregroundStyle(networkState != 3 ? Color.secondary : .primary)
                        } else if bilibiliAPIState == 1 {
                            Text("Bilibili API：正在检查")
                        } else if bilibiliAPIState == 2 {
                            Text("Bilibili API：不可用")
                        } else if bilibiliAPIState == 3 {
                            Text("Bilibili API：可用")
                        }
                        Spacer()
                    }
                    .disabled(networkState != 3)
                    .padding()
                    Button(action: {
                        isTroubleshooting = true
                        networkState = 0
                        darockAPIState = 0
                        bilibiliAPIState = 0
                        checkInternet()
                        func checkInternet() {
                            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                                timer.invalidate()
                                networkState = 1
                                DarockKit.Network.shared.requestString("https://apple.com.cn") { _, isSuccess in
                                    if isSuccess {
                                        checkDarock()
                                        networkState = 3
                                    } else {
                                        networkState = 2
                                        isTroubleshooting = false
                                    }
                                }
                            }
                            
                            func checkDarock() {
                                darockAPIState = 1
                                DarockKit.Network.shared.requestString("https://api.darock.top") { respStr, isSuccess in
                                    if isSuccess {
                                        if respStr.apiFixed() == "OK" {
                                            darockAPIState = 3
                                        } else {
                                            darockAPIState = 4
                                        }
                                    } else {
                                        darockAPIState = 1
                                    }
                                    checkBilibili()
                                }
                            }
                            
                            func checkBilibili() {
                                bilibiliAPIState = 2
                                DarockKit.Network.shared.requestString("https://api.bilibili.com/") { _, isSuccess in
                                    if isSuccess {
                                        bilibiliAPIState = 3
                                    } else {
                                        bilibiliAPIState = 2
                                    }
                                }
                                isTroubleshooting = false
                            }
                        }
                    }, label: {
                        Text(isTroubleshooting ? "正在检查..." : "重新检查")
                    })
                    .disabled(isTroubleshooting)
                }
            }
            /* VStack {
                if !isFinish {
                    ProgressView(value: progress, total: 100.0)
                        .progressViewStyle(.linear)
                        .foregroundColor(.blue)
                    Text("正在\(fixingItem)")
                } else {
                    if troubles.count != 0 {
                        List {
                            Section {
                                Text("Troubleshooter.what-we-found")
                            }
                            Section {
                                ForEach(0...troubles.count - 1, id: \.self) { i in
                                    Text(troubles[i])
                                        .bold()
                                        .onAppear {
                                            if troubles[i].contains("Darock") {
                                                isDarockIssue = true
                                            } else if troubles[i] == "Troubleshooter.no-internet" {
                                                isNetworkIssue = true
                                            }
                                        }
                                }
                            }
                            if isNetworkIssue {
                                Section {
                                    NavigationLink(destination: {UserNetworkGuide()}, label: {
                                        Text("问题来自您的网络连接，点此查看网络说明")
                                    })
                                }
                            }
                            if isDarockIssue {
                                Section {
                                    Text("问题可能来自 Darock，请联系开发者或等待问题解决")
                                }
                            }
                        }
                    } else {
                        Text("Troubleshooter.failed")
                        Text("Troubleshooter.failed.discription") //请重试之前的操作，如果问题依然存在，请联系开发者
                    }
                }
            }*/
        }
        .onAppear {
            isTroubleshooting = true
            networkState = 0
            darockAPIState = 0
            bilibiliAPIState = 0
            checkInternet()
            func checkInternet() {
                Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                    timer.invalidate()
                    networkState = 1
                    DarockKit.Network.shared.requestString("https://baidu.com") { _, isSuccess in
                        if isSuccess {
                            checkDarock()
                            networkState = 3
                        } else {
                            networkState = 2
                            isTroubleshooting = false
                        }
                    }
                }
            }
            
            /* func checkDarockTest() {
                Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { timer in
                    timer.invalidate()
                    darockAPIState = 1
                    DarockKit.Network.shared.requestString("https://baidu.com") { _, isSuccess in
                        if isSuccess {
                            darockAPIState = 3
                        } else {
                            darockAPIState = 2
                            isTroubleshooting = false
                        }
                    }
                }
            } */
            
            func checkDarock() {
                darockAPIState = 1
                DarockKit.Network.shared.requestString("https://api.darock.top") { respStr, isSuccess in
                    Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { timer in
                        if isSuccess {
                            if respStr.apiFixed() == "OK" {
                                darockAPIState = 3
                            } else {
                                darockAPIState = 4
                                isTroubleshooting = false
                            }
                        } else {
                            darockAPIState = 4
                            isTroubleshooting = false
                        }
                        timer.invalidate()
                    }
                    checkBilibili()
                }
                
            }
                
            func checkBilibili() {
                bilibiliAPIState = 2
                DarockKit.Network.shared.requestString("https://api.bilibili.com/") { _, isSuccess in
                    if isSuccess {
                        bilibiliAPIState = 3
                    } else {
                        bilibiliAPIState = 2
                    }
                }
                isTroubleshooting = false
            }
            }
        .onDisappear {
            progressTimer?.invalidate()
        }
    }
}

struct networkProblemDetailsView: View {
    var body: some View {
        List {
            Section {
                Text("网络问题")
                    .bold()
            }
            Section("这代表什么？") {
                Text("Apple Watch 目前无法连接到互联网")
            }
            Section("我应当怎么做？") {
                Text("确认 Apple Watch 已连接到互联网")
                Text("确认已在手机端同意网络权限")
            }
        }
    }
}

struct darockAPIProblemDetailsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Darock API 问题")
                        .bold()
                }
                Section("这代表什么？") {
                    Text("Darock API 服务器目前出现了问题")
                }
                Section("我应当怎么做？") {
                    Text("联系 Darock 或等待修复")
                }
            }
        }
    }
}

struct bilibiliAPIProblemDetailsView: View {
    var body: some View {
        List {
            Section {
                Text("Bilibili API 问题")
                    .bold()
            }
            Section("这代表什么？") {
                Text("目前无法连接到 Bilibili 服务器，可能是您的网络出现问题。在少部分情况下，Bilibili 服务器可能已宕机")
            }
            Section("我应当怎么做？") {
                Text("检查网络或稍后重试")
            }
        }
    }
}

/* struct UserNetworkGuide: View {
    var body: some View {
        List {
            Section {
                Text("网络说明")
            }
            Section {
                Text("您应当确认：")
                    .bold()
                Text("Watch 的状态栏（控制中心上方）显示为\(Image(systemName: "wifi"))而不是\(Image(systemName: "iphone"))")
            }
            Section {
                Text("怎么做？")
                Text("关闭 iPhone 的 Wi-Fi 以及蓝牙")
                    .bold()
            }
        }
    }
} */

struct NetworkFixView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkFixView()
    }
}
