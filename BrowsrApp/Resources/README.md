# ``BrowsrAPP``

BrowsrApp is an iOS app that allows users to browse and explore GitHub organizations. It leverages the BrowsrLib library to interact with the GitHub API and fetch organization data.

## Features

- View a list of GitHub organizations.
- View detailed information about each organization, including its avatar picture.
- Mark organizations as favorites.
- View a list of favorite organizations.


## Architecture (MVVM)

BrowsrApp follows the MVVM (Model-View-ViewModel) architectural pattern to separate the concerns of the app's components. The MVVM architecture consists of the following components:

- Model: Represents the data and business logic of the app. In BrowsrApp, the `Organization` model represents the data for GitHub organizations.

- View: Represents the user interface of the app. In BrowsrApp, the views are implemented using UIKit elements.

- ViewModel: Acts as a mediator between the View and the Model. It provides data and state to the View and handles user interactions. In BrowsrApp, the `OrganizationsViewModel` class serves as the ViewModel.

The MVVM architecture promotes a clear separation of concerns, making the app more maintainable and testable. It also allows for better code organization and reduces coupling between different components.

## Dependencies

BrowsrApp relies on the BrowsrLib library to interact with the GitHub API and handle data fetching and caching. The BrowsrLib library follows SOLID principles and provides various components such as the `BrowsrClient` for API interactions, the `ImageDownloader` for image downloading, and the `CacheManager` for data caching.
