# Contributing to Moonbar

Thank you for your interest in contributing to Moonbar! This document provides guidelines and information for contributors.

## Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to uphold this code. Please report unacceptable behavior to the project maintainers.

## How to Contribute

### Reporting Bugs

Before creating bug reports, please check the existing issues to avoid duplicates. When creating a bug report, include:

- **Clear description** of the issue
- **Steps to reproduce** the behavior
- **Expected behavior** vs actual behavior
- **Environment details** (macOS version, Xcode version, etc.)
- **Screenshots** if applicable

### Suggesting Features

Feature suggestions are welcome! Please:

- Check existing feature requests first
- Provide a clear description of the feature
- Explain the use case and benefits
- Consider the scope and complexity

### Pull Requests

1. **Fork** the repository
2. **Create a feature branch** from `main`
3. **Make your changes** following the coding standards
4. **Add tests** for new functionality
5. **Update documentation** as needed
6. **Commit** with clear, descriptive messages
7. **Push** to your fork and submit a pull request

#### Pull Request Guidelines

- Keep changes focused and atomic
- Write clear commit messages
- Include tests for new features
- Update documentation
- Follow the existing code style
- Ensure all tests pass

## Development Setup

### Prerequisites

- macOS 12.0+
- Xcode 14.0+
- Git

### Local Development

1. Clone your fork:
   ```bash
   git clone https://github.com/yourusername/moonbar.git
   cd moonbar
   ```

2. Set up environment:
   ```bash
   export MOONSHOT_API_KEY="your-test-api-key"
   ```

3. Open in Xcode:
   ```bash
   open Moonbar.xcodeproj
   ```

4. Build and test:
   ```bash
   ⌘B  # Build
   ⌘U  # Run tests
   ```

## Coding Standards

### Swift Style Guide

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Keep functions focused and small
- Use `// MARK:` to organize code sections

### Code Organization

```swift
// MARK: - Properties
private let property: Type

// MARK: - Initialization
init() { }

// MARK: - Public Methods
func publicMethod() { }

// MARK: - Private Methods
private func privateMethod() { }
```

### Testing

- Write unit tests for all new functionality
- Use descriptive test names: `test_fetchBalance_withValidKey_returnsBalance()`
- Mock external dependencies
- Aim for >90% code coverage on core logic

### Documentation

- Document all public APIs with Swift documentation comments
- Update README.md for user-facing changes
- Update architecture documentation for structural changes

## Adding New Providers

To add support for a new AI provider:

### 1. Implement BalanceProvider Protocol

```swift
struct NewProvider: BalanceProvider {
    let name = "Provider Name"
    let baseURL = "https://api.provider.com"
    
    func fetchBalance(apiKey: String) async throws -> ProviderBalance {
        // Implementation
    }
    
    func validateApiKey(_ apiKey: String) async throws -> Bool {
        // Implementation
    }
}
```

### 2. Create Provider-Specific Balance Model

```swift
struct NewProviderBalance: ProviderBalance {
    let mainBalance: Double
    let otherBalances: [String: Double]
    let lastUpdated: Date
    
    var primaryBalance: Double { mainBalance }
    var secondaryBalances: [String: Double] { otherBalances }
    var currency: String { "USD" }
}
```

### 3. Add Tests

```swift
class NewProviderTests: XCTestCase {
    func test_fetchBalance_withValidKey_returnsBalance() {
        // Test implementation
    }
    
    func test_validateApiKey_withValidKey_returnsTrue() {
        // Test implementation
    }
}
```

### 4. Update Documentation

- Add provider to README.md
- Document any provider-specific features
- Update architecture documentation

## Commit Message Format

Use clear, descriptive commit messages:

```
type(scope): description

- feat: new feature
- fix: bug fix
- docs: documentation changes
- style: formatting changes
- refactor: code refactoring
- test: adding tests
- chore: maintenance tasks
```

Examples:
```
feat(providers): add OpenAI provider support
fix(balance): handle network timeout gracefully
docs(readme): update installation instructions
test(moonshot): add error handling tests
```

## Release Process

1. Update version numbers in code
2. Update CHANGELOG.md
3. Run full test suite
4. Create release PR
5. Tag release after merge
6. Update GitHub release notes

## Getting Help

- **Questions**: Use GitHub Discussions
- **Issues**: Create GitHub Issues
- **Chat**: Contact maintainers directly

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- GitHub contributors page

Thank you for contributing to Moonbar! 🚀