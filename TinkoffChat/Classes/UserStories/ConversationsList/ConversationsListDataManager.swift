//
//  ConversationsListDataManager.swift
//  TinkoffChat
//
//  Created by Alexander Peresypkin on 06/10/2018.
//  Copyright © 2018 Alexander Peresypkin. All rights reserved.
//

import UIKit

class ConversationsListDataManager {
    
    typealias ViewModel = ConversationsListViewController.Section
    typealias Item = ConversationsListViewController.ViewModel
    
    func obtainConversationsList(completion: ([ViewModel]) -> Void) {
        let onlineItems = fakeModels.filter { $0.online }.map { prepareItem(for: $0) }
        let historyItems = fakeModels.filter { !$0.online && $0.message != nil }.map { prepareItem(for: $0) }
        
        var viewModels: [ViewModel] = []
        
        if !onlineItems.isEmpty {
            viewModels.append(ViewModel(sectionType: .online, items: onlineItems))
        }

        if !historyItems.isEmpty {
            viewModels.append(ViewModel(sectionType: .history, items: historyItems))
        }
        
        completion(viewModels)
    }
    
    private func prepareItem(for model: FakeModel) -> Item {
        return Item(name: model.name ?? "Unnamed",
                    message: model.message ?? "No messages yet",
                    font: prepareFont(for: model),
                    date: prepareDate(for: model),
                    backgroundColor: model.online ? .lightYellow : .white,
                    online: model.online)
    }
    
    private func prepareFont(for model: FakeModel) -> UIFont {
        if model.message != nil {
            return model.hasUnreadMessages ? UIFont.boldSystemFont(ofSize: UIFont.systemFontSize) : UIFont.systemFont(ofSize: UIFont.systemFontSize)
        } else {
            return UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)
        }
    }
    
    private func prepareDate(for model: FakeModel) -> String {
        let dateFormatter = DateFormatter()
        if let date = model.date {
            dateFormatter.dateFormat = date.isToday ? "HH:mm" : "dd MMM"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    // Заглушка
    private struct FakeModel {
        let name: String?
        let message: String?
        let date: Date?
        let online: Bool
        let hasUnreadMessages: Bool
    }
    
    private let fakeModels = [FakeModel(name: nil, message: nil, date: nil, online: false, hasUnreadMessages: false),
                              FakeModel(name: "Cole Sprouse", message: nil, date: Date(), online: false, hasUnreadMessages: false),
                              FakeModel(name: "Thomas Sangster", message: "Томас Броди-Сангстер – английский киноактер, по мнению многих, имеющий прирожденный талант к перевоплощению", date: Date(), online: false, hasUnreadMessages: false),
                              FakeModel(name: "Lili Reinhart", message: "Лили Рейнхарт – американская актриса, прославившаяся благодаря главной роли в молодежном сериале «Ривердэйл»", date: Date(), online: true, hasUnreadMessages: false),
                              FakeModel(name: "Jackie Chan", message: "Джеки Чан (имя при рождении Чэнь Ганшэн, в другой транскрипции Чань Консан (Чань, рожденный в Гонконге), англ. Jackie Chan) – гонконгский, китайский и американский актер, каскадер и мастер боевых искусств, а также певец и филантроп.", date: Date(), online: true, hasUnreadMessages: true),
                              FakeModel(name: nil, message: "БИОГРАФИЯ ДИЛАНА О’БРАЙЕНА", date: Date(), online: false, hasUnreadMessages: false),
                              FakeModel(name: "Finn Wolfhard", message: "Финн Вулфхард – молодой актер и музыкант из Канады", date: nil, online: false, hasUnreadMessages: false),
                              FakeModel(name: "Emma Watson", message: nil, date: Date(), online: true, hasUnreadMessages: true),
                              FakeModel(name: "Jaeden Lieberher", message: nil, date: Date(), online: true, hasUnreadMessages: false),
                              FakeModel(name: "K.J. Apa", message: "Кей Джей Апа – актер новозеландского происхождения", date: Date(), online: false, hasUnreadMessages: true),
                              FakeModel(name: "Vin Diesel", message: "Американский киноактер", date: Date(), online: true, hasUnreadMessages: false),
                              FakeModel(name: "Jason Statham", message: nil, date: Date(), online: false, hasUnreadMessages: false),
                              FakeModel(name: "Tom Hiddleston", message: nil, date: Date(), online: false, hasUnreadMessages: false),
                              FakeModel(name: "Keanu Reeves", message: nil, date: Date(), online: false, hasUnreadMessages: false),
                              FakeModel(name: nil, message: nil, date: Date.yesterday, online: false, hasUnreadMessages: false),
                              FakeModel(name: "Johnny Depp", message: nil, date: Date.yesterday, online: false, hasUnreadMessages: false),
                              FakeModel(name: "Angelina Jolie", message: "Анджелина Джоли Войт – голливудская актриса", date: Date.yesterday, online: false, hasUnreadMessages: false),
                              FakeModel(name: "Madelaine Petsch", message: "Мэделин Петш (Madelaine Petsch) – американская актриса, популярность которой принесла роль Шерил Блоссом в телесериале «Ривердэйл».", date: Date.yesterday, online: true, hasUnreadMessages: false),
                              FakeModel(name: "Theo James", message: "Тео Джеймс – молодой британский актер, который стал настоящей голливудской сенсацией после выхода первой части нашумевшей франшизы «Дивергент».", date: Date.yesterday, online: true, hasUnreadMessages: true),
                              FakeModel(name: "Dwayne Johnson", message: "Rock!", date: Date.yesterday, online: false, hasUnreadMessages: true),
                              FakeModel(name: nil, message: nil, date: Date.yesterday, online: true, hasUnreadMessages: true),
                              FakeModel(name: "Tom Hardy", message: nil, date: Date.yesterday, online: true, hasUnreadMessages: true),
                              FakeModel(name: nil, message: "Милли Бобби Браун — британско-американская актриса и модель", date: Date.yesterday, online: false, hasUnreadMessages: false),
                              FakeModel(name: nil, message: "Роберт Томас Паттинсон – британский актер", date: Date.yesterday, online: true, hasUnreadMessages: false),
                              FakeModel(name: nil, message: "Кристен Джеймс Стюарт (Kristen Stewart, ошибочно - Кристин Стюарт, Кристен Стюард) – американская актриса", date: Date.yesterday, online: false, hasUnreadMessages: true),
                              FakeModel(name: "Emilia Clarke", message: "г. Лондон, Великобритания", date: Date.yesterday, online: false, hasUnreadMessages: false),
                              FakeModel(name: "Milos Bikovic", message: "г. Белград, Сербия", date: Date.yesterday, online: false, hasUnreadMessages: false),
                              FakeModel(name: "Ariana Grande", message: "г. Бока-Ратон, Флорида, США", date: Date.yesterday, online: false, hasUnreadMessages: false),
                              FakeModel(name: "Megan Fox", message: "Роквуд, США", date: Date.yesterday, online: false, hasUnreadMessages: false)]
    
}

// Временно, для фейковых моделей
private extension Date {
    static var yesterday: Date? {
        let today = Date()
        return Calendar.current.date(byAdding: .day, value: -1, to: today)
    }
}
