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
    
    func printResults() {
        print("from results", fromModel.results)
        print("to results", toModel.results)
        
        print(focusedField == .from ? "focused on from" : "focused on to")
    }
    
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
                }
            })
            
            ScrollView {
                LazyVStack {
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
                        if activeShow == .from {
                            Button(action: {
                                fromModel.query = result.name
                                fromPlace = result
                                focusedField = .to
                            }) {
                                TripInitResultItemView(result)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else if activeShow == .to {
                            NavigationLink {
                                Text("To be implemented")
                            } label: {
                                Button(action: {
                                    toModel.query = result.name
                                    toPlace = result
                                }) {
                                    TripInitResultItemView(result)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
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
