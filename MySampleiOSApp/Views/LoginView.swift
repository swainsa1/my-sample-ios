import SwiftUI

struct LoginView: View {

    // MARK: - Properties

    @StateObject private var viewModel = LoginViewModel()
    @FocusState private var focusedField: Field?

    // MARK: - Field Enum

    private enum Field {
        case email
        case password
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                // Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Logo/Header
                        headerView

                        // Form
                        formView

                        // Login Button
                        loginButton

                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            errorView(message: errorMessage)
                        }

                        // Success Message
                        if viewModel.isLoggedIn {
                            successView
                        }

                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Subviews

    private var headerView: some View {
        VStack(spacing: 12) {
            Image(systemName: "lock.shield.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(.blue)

            Text("Welcome Back")
                .font(.title)
                .fontWeight(.bold)

            Text("Sign in to continue")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 40)
        .padding(.bottom, 20)
    }

    private var formView: some View {
        VStack(spacing: 20) {
            // Email Field
            VStack(alignment: .leading, spacing: 8) {
                emailField

                if let errorMessage = viewModel.emailError {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            // Password Field
            VStack(alignment: .leading, spacing: 8) {
                passwordField

                if let errorMessage = viewModel.passwordError {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
    }

    private var emailField: some View {
        HStack {
            Image(systemName: "envelope.fill")
                .foregroundColor(.secondary)
                .frame(width: 20)

            TextField("Email", text: $viewModel.email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor(for: .email), lineWidth: 1)
        )
    }

    private var passwordField: some View {
        HStack {
            Image(systemName: "lock.fill")
                .foregroundColor(.secondary)
                .frame(width: 20)

            SecureField("Password", text: $viewModel.password)
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit {
                    Task {
                        await viewModel.login()
                    }
                }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor(for: .password), lineWidth: 1)
        )
    }

    private var loginButton: some View {
        Button(action: {
            Task {
                await viewModel.login()
            }
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Sign In")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.isFormValid ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(!viewModel.isFormValid)
    }

    private func errorView(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.red)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.1))
        .cornerRadius(10)
    }

    private var successView: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)

            Text("Login successful!")
                .font(.subheadline)
                .foregroundColor(.green)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.green.opacity(0.1))
        .cornerRadius(10)
    }

    // MARK: - Helper Methods

    private func borderColor(for field: Field) -> Color {
        guard focusedField == field else {
            return Color(.systemGray4)
        }

        switch field {
        case .email:
            return viewModel.email.isEmpty || viewModel.emailError == nil ? .blue : .red
        case .password:
            return viewModel.password.isEmpty || viewModel.passwordError == nil ? .blue : .red
        }
    }
}

// MARK: - Preview

#Preview {
    LoginView()
}
