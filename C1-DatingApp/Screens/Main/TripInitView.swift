//
//  TripInitView.swift
//  C1-DatingApp
//
//  Created by Ramdan on 12/04/25.
//

import SwiftUI

enum FieldFocus: Hashable {
    case from
    case to
}

struct TripInitView: View {
    @StateObject private var fromModel: SearchViewModel = SearchViewModel()
    @StateObject private var toModel: SearchViewModel = SearchViewModel()
    @State private var fromPlace: Place?
    @State private var toPlace: Place?
    @FocusState private var focusedField: FieldFocus?
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    @State private var activeShow: FieldFocus = .from
    @State private var isCompleted: Bool = true
 
    var body: some View {
        VStack {
            TripInitSearchView(
                fromAddress: $fromModel.query,
                toAddress: $toModel.query,
                fromPlace: $fromPlace,
                toPlace: $toPlace,
                fromSearchFunction: fromModel.search,
                toSearchFunction: toModel.search,
                focusedField: $focusedField
            )
            .onChange(of: focusedField, {
                if let focusedField = focusedField {
                    activeShow = focusedField
                    isCompleted = false
                }
            })
            
            ScrollView {
                LazyVStack {
                    if(!isCompleted) {
                        let listData = {
                            if activeShow == .from {
                                return fromModel.results
                            } else if activeShow == .to {
                                return toModel.results
                            } else {
                                return []
                            }
                        }()
                        
                        ForEach(listData) { result in
                            Button(action: {
                                if activeShow == .from {
                                    fromModel.query = result.name
                                    fromPlace = result
                                    focusedField = .to
                                } else {
                                    toModel.query = result.name
                                    toPlace = result
                                    
                                    isCompleted = true
                                }
                            }) {
                                TripInitResultItemView(result)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    } else {
                        TripInitFormView()
                    }
                }
                .padding(.horizontal)
                .padding(.top)
            }
            
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                })
                {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .gesture(
            DragGesture()
                .updating(
                    $dragOffset,
                    body: { (value, state, transaction) in
                        if(value.startLocation.x < 20 && value.translation.width > 100) {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
        )
    }
}

#Preview {
    TripInitView()
}
