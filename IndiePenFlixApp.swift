import SwiftUI
import AVKit

@main
struct INDEPENFLIXApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var isRegistering = false
    
    var body: some View {
        if isLoggedIn {
            DashboardView()
        } else if isRegistering {
            RegisterView(isRegistering: $isRegistering, isLoggedIn: $isLoggedIn)
        } else {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack(spacing: 20) {
                    Text("Welcome to IndiePenflix")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    VStack(spacing: 20) {
                        TextField("Email", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .foregroundColor(.white)
                            .accentColor(.green)
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .accentColor(.green)
                    }
                    .padding(.horizontal, 40)
                    
                    VStack(spacing: 15) {
                        Button(action: {
                            // Simulated login validation
                            if email == "test@test.com" && password == "Test123!" {
                                isLoggedIn = true
                            }
                        }) {
                            Text("Login")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            isRegistering = true
                        }) {
                            Text("Register")
                                .foregroundColor(.green)
                                .underline()
                        }
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
    }
}

struct RegisterView: View {
    @Binding var isRegistering: Bool
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var passwordValidation = PasswordValidation()
    @State private var showError = false
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("Register")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .foregroundColor(.white)
                        .accentColor(.green)
                    
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    
                    SecureField("Password", text: $password, onCommit: {
                        passwordValidation = PasswordValidation.validate(password: password)
                    })
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        PasswordRequirementRow(
                            isMet: passwordValidation.containsUppercase,
                            text: "At least one uppercase letter"
                        )
                        PasswordRequirementRow(
                            isMet: passwordValidation.containsLowercase,
                            text: "At least one lowercase letter"
                        )
                        PasswordRequirementRow(
                            isMet: passwordValidation.containsDigit,
                            text: "At least one digit"
                        )
                        PasswordRequirementRow(
                            isMet: passwordValidation.containsSpecialCharacter,
                            text: "At least one special character"
                        )
                        PasswordRequirementRow(
                            isMet: passwordValidation.isLongEnough,
                            text: "At least 8 characters"
                        )
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.horizontal, 40)
                
                Button(action: {
                    if passwordValidation.isValid {
                        isRegistering = false
                        isLoggedIn = true
                    } else {
                        showError = true
                    }
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(passwordValidation.isValid ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .disabled(!passwordValidation.isValid)
                
                Button(action: {
                    isRegistering = false
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .underline()
                }
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text("Password requirements not met"), dismissButton: .default(Text("OK")))
        }
    }
}

struct DashboardView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text("Uploaded Movies")) {
                    Text("Uploaded Movies")
                }
                NavigationLink(destination: Text("Favorite Movies")) {
                    Text("Favorite Movies")
                }
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct PasswordRequirementRow: View {
    var isMet: Bool
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: isMet ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isMet ? .green : .red)
            Text(text)
                .foregroundColor(.white)
        }
    }
}

struct PasswordValidation {
    var containsUppercase = false
    var containsLowercase = false
    var containsDigit = false
    var containsSpecialCharacter = false
    var isLongEnough = false
    
    var isValid: Bool {
        containsUppercase && containsLowercase && containsDigit && containsSpecialCharacter && isLongEnough
    }
    
    static func validate(password: String) -> PasswordValidation {
        var validation = PasswordValidation()
        validation.containsUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        validation.containsLowercase = password.range(of: "[a-z]", options: .regularExpression) != nil
        validation.containsDigit = password.range(of: "\\d", options: .regularExpression) != nil
        validation.containsSpecialCharacter = password.range(of: "[^a-zA-Z\\d\\s]", options: .regularExpression) != nil
        validation.isLongEnough = password.count >= 8
        return validation
    }
    
}
