//
//  DogBreedRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public protocol LocalDogBreedRepository: ViewDataCollectionRepository<BreedListItem, DogBreedViewDataAction, Void> { }

public enum DogBreedViewDataAction {
    case refresh
}
