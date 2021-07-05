//
//  HistoryView.swift
//  Scrumdinger
//
//  Created by 정성훈 on 2021/07/05.
//

import SwiftUI

struct HistoryView: View {
    let history: History
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Divider()
                    .padding(.bottom)
                Text("참가자")
                    .font(.headline)
                if let transcript = history.transcript {
                    Text("변환본")
                        .font(.headline)
                        .padding(.top)
                    Text(transcript)
                }
            }
        }
        .navigationTitle(Text(history.date, style: .date))
        .padding()
    }
}

extension History {
    var attendeeString: String {
        ListFormatter.localizedString(byJoining: attendees)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(history: History(attendees: ["김철수", "김영희", "홍길동"], lengthInMinutes: 10, transcript: "나는야 퉁퉁이 골목 대장이라네~ 나는야 퉁퉁 우리 거북선 통통"))
    }
}
