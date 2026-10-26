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
When the user taps Get a signup tip, the app clears any previous tip or error, shows “Loading tip...” text, and disables the button so repeated taps can’t start duplicate requests. If the mock succeeds, the tip appears beneath the button under a “Signup Tip (Mock)” label, limited to 240 characters. If it fails, the app shows a friendly error message with a Retry button that starts a new request, and the signup form keeps working either way.
### Question 2: Why should signup validation remain local?
The app validates the signup fields itself because validation is a decision, while an AI tip is only advice, and a decision should be predictable. Local rules give the same result every time, work even if the AI service is down, and keep the user’s name, email, and password on their device, since the tip request sends only a generic topic. An AI tip also can’t prove a password is secure, so it should never override a local validation error.
## Contributions
**Student:** Eyobed Gebregziabher


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