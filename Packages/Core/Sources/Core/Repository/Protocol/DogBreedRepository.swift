//
//  DogBreedRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/17.
//

import Foundation

public protocol DogBreedRepository: ViewDataCollectionRepository<BreedListItem, DogBreedCollectionAction, Void> { }

public enum DogBreedCollectionAction {
    case refresh
}
