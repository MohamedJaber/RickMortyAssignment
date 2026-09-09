import Foundation

final class AppFactory {
    // Network configuration
    private lazy var networkConfiguration: NetworkConfiguration = {
        let baseURL = URL(string: "https://rickandmortyapi.com/api")!
        return NetworkConfiguration(
            baseURL: baseURL,
            environment: .production,
            timeoutInterval: 30
        )
    }()
    
    // Generic HTTP client - can be used for ANY API
    private lazy var httpClient: HTTPClientProtocol = {
        HTTPClient(
            configuration: networkConfiguration,
            interceptors: [],
            logger: DefaultNetworkLogger()
        )
    }()

    // Repositories - use httpClient directly
    private lazy var characterRepository: CharacterRepositoryProtocol = {
        CharacterRepository(httpClient: httpClient)
    }()
    
    private lazy var episodeRepository: EpisodeRepositoryProtocol = {
        EpisodeRepository(httpClient: httpClient)
    }()
    
    // Persistence
    private lazy var persistenceController: PersistenceController = {
        PersistenceController.shared
    }()
    
    // ViewModels
    lazy var characterListViewModel: CharactersListViewModel = {
        CharactersListViewModel(
            characterRepository: characterRepository,
            persistenceController: persistenceController
        )
    }()
    
    func createCharacterDetailViewModel(character: Character) -> CharacterDetailViewModel {
        CharacterDetailViewModel(
            character: character,
            episodeRepository: episodeRepository,
            persistenceController: persistenceController
        )
    }
}
