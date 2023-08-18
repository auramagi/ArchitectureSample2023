//
//  DogRepository.swift
//  
//
//  Created by Mikhail Apurin on 2023/08/16.
//

import Foundation

public protocol DogRepository {
    func getRandomDogImage() async throws -> URL

    func getDogBreedImage(breed: Breed) async throws -> URL

    func getDogSubBreedImage(breed: Breed, subBreed: SubBreed) async throws -> URL

    func getBreedList() async throws -> BreedList
}
