# MySampleiOSApp

A sample iOS login application demonstrating modern iOS development best practices with SwiftUI, MVVM architecture, and comprehensive testing.

## Features

- **Modern SwiftUI Interface**: Beautiful, responsive login screen with real-time validation feedback
- **MVVM Architecture**: Clean separation of concerns with ViewModels and Services
- **Real-time Validation**: Instant feedback on email and password input with debouncing
- **Async/Await**: Modern Swift concurrency for authentication operations
- **Combine Framework**: Reactive programming for validation and data binding
- **Comprehensive Testing**: Full unit test coverage for ViewModels and Services
- **Mock Authentication**: Demo authentication service with test credentials

## Architecture

### MVVM Pattern

```
Views (SwiftUI)
    |
    v
ViewModels (Observable Objects)
    |
    v
Services (Business Logic)
```

### Components

#### ViewModels
- **LoginViewModel**: Manages login state, validation, and authentication flow
  - Published properties for UI binding
  - Real-time validation with debouncing
  - Async login operations
  - Form validation state

#### Services
- **AuthenticationService**: Handles user authentication
  - Mock login with test credentials
  - Async login/logout operations
  - User session management

- **ValidationService**: Validates user input
  - Email format validation
  - Password strength validation (minimum 8 characters, uppercase, number)

#### Views
- **LoginView**: SwiftUI login interface
  - Email and password input fields
  - Real-time validation error display
  - Loading states during authentication
  - Success/error messaging

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd my-sample-ios
```

2. Open the project in Xcode:
```bash
open MySampleiOSApp.xcodeproj
```

3. Build and run the project (Cmd+R)

## Test Credentials

Use these credentials to test the login functionality:

- **Email**: test@example.com
- **Password**: Password123

## Running Tests

1. In Xcode, press `Cmd+U` to run all tests
2. Or use the Test Navigator (Cmd+6) to run individual test suites

### Test Coverage

- **LoginViewModelTests**: Tests for login flow, validation, and state management
- **ValidationServiceTests**: Tests for email and password validation rules
- **AuthenticationServiceTests**: Tests for authentication operations and error handling

## Validation Rules

### Email
- Required field
- Must be valid email format (user@domain.com)

### Password
- Required field
- Minimum 8 characters
- At least one uppercase letter
- At least one number

## Project Structure

```
MySampleiOSApp/
├── App/
│   ├── MySampleiOSApp.swift          # App entry point
│   └── ContentView.swift             # Root view
├── ViewModels/
│   └── LoginViewModel.swift          # Login view model
├── Services/
│   ├── AuthenticationService.swift   # Authentication logic
│   └── ValidationService.swift       # Input validation
└── Assets.xcassets/                  # App assets

MySampleiOSAppTests/
├── LoginViewModelTests.swift         # ViewModel tests
├── ValidationServiceTests.swift      # Validation tests
└── AuthenticationServiceTests.swift  # Auth service tests
```

## Key Technologies

- **SwiftUI**: Declarative UI framework
- **Combine**: Reactive programming framework for validation
- **Async/Await**: Modern concurrency for asynchronous operations
- **XCTest**: Unit testing framework
- **@MainActor**: Main thread isolation for UI updates
- **@Published**: Property wrapper for observable properties

## Design Patterns

1. **MVVM (Model-View-ViewModel)**: Separation of UI and business logic
2. **Dependency Injection**: Services injected into ViewModels for testability
3. **Protocol-Oriented Programming**: Service protocols for mocking in tests
4. **Observer Pattern**: Combine publishers for reactive updates
5. **Single Responsibility**: Each component has one clear purpose

## Future Enhancements

- [ ] Biometric authentication (Face ID/Touch ID)
- [ ] Keychain integration for secure credential storage
- [ ] Password reset functionality
- [ ] Social login options (Apple, Google)
- [ ] Remember me functionality
- [ ] Network layer with real API integration
- [ ] Localization support
- [ ] Dark mode optimization

## Development Notes

### Mock Authentication
The `AuthenticationService` uses mock authentication for demonstration purposes. In a production app, this would connect to a real backend API.

### Validation Debouncing
Email and password validation use a 500ms debounce to avoid excessive validation during typing, improving performance and user experience.

### Testing Strategy
The project uses mock implementations of services to enable comprehensive unit testing without external dependencies.

## License

This is a sample project for educational purposes.

## Contributing

This is a sample project. Feel free to fork and modify for your learning purposes.

## Support

For questions or issues, please open an issue in the repository.

---

Built with SwiftUI and modern iOS development best practices.
