//
//  CountryListView.swift
//  clientApp
//
//  Created by Manjinder Sandhu on 23/09/23.
//

import SwiftUI

func countryFlag(_ countryCode: String) -> String {
  String(String.UnicodeScalarView(countryCode.unicodeScalars.compactMap {
    UnicodeScalar(127397 + $0.value)
  }))
}

struct CountryListView: View {
  var body: some View {
    List(NSLocale.isoCountryCodes, id: \.self) { countryCode in
      HStack {
        Text(countryFlag(countryCode))
        Text(Locale.current.localizedString(forRegionCode: countryCode) ?? "")
        Spacer()
        Text(countryCode)
      }
    }
  }
}

#Preview {
    CountryListView()
}
