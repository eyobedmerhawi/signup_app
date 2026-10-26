# Flutter Signup Form Quest

## Project Overview
A Flutter signup application featuring local form validation and an AI Signup Coach demonstration. The app provides general password advice while keeping signup validation separate from the advice feature.

## Track
**Undergraduate — Task A: AI Signup Coach**

## Features
- Full name, email, and password input fields
- Local form validation and signup feedback
- Get a signup tip button
- Loading feedback and prevention of duplicate requests
- Signup tips displayed below the button
- Error handling with a Retry option
- Testing switch to simulate service failures
- Maximum tip display length of 240 characters

## AI Service and Privacy
This project uses a deterministic mock service because no instructor AI endpoint was provided. No live AI model is called.

The signup tip feature provides general password advice only. The mock service does not receive the user's name, email, or password, and its response does not determine whether signup succeeds.

## Testing
The application was tested for:
- Empty and invalid signup fields
- Successful local form validation
- Successful mock signup tip response
- Simulated mock failure
- Recovery using Retry
- Loading feedback and duplicate-request prevention

## Reflection Questions

### Question 1: How does the AI Signup Coach work?
[Insert your finalized three-sentence answer here.]

### Question 2: Why should signup validation remain local?
[Insert your finalized three-sentence answer here.]

## Contributions
**Student:** [Your name]

[Describe your contributions and list your partner's contributions if applicable.]

## Running the Project
1. Open the project in VS Code or Android Studio.
2. Run `flutter pub get`.
3. Start an emulator or connect an Android device.
4. Run `flutter run`.

## Building the APK
Run `flutter build apk --release`.

The generated APK is located at:

`build/app/outputs/flutter-apk/app-release.apk`

## Submission
- GitHub repository: [Insert repository URL]
- Release APK: Submitted separately