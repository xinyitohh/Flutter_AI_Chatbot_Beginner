# Flutter AI Chatbot for Beginner

A conversational AI chatbot built using **Flutter**, **Gemini AI**, **Provider** for state management, and **Hive** for local database. 🚀

---

## 🔥 Features
- 🌐 **Gemini API Integration** - Fetch responses from an AI-powered backend.
- 📷 **Image Handling** - Supports both text and image-based responses.
- 🗃 **Conversation History** - Saves chat history for a seamless experience.
- 📝 **Hive Local Database** - Store chat history locally.


---

## 🖼️ Image Preview

<p align="center">
  <img src="https://i.imgur.com/hOxhEer.jpeg" width="45%" />
  <img src="https://i.imgur.com/StHb2sg.jpeg" width="45%" />
</p>


## 🛠 Installation & Setup

### 1️⃣ Clone the Repository
```sh
git clone https://github.com/your-username/flutter-chatbot.git
cd flutter-chatbot
```

### 2️⃣ Install Dependencies
```sh
flutter pub get
```

### 3️⃣ Setup Environment Variables
Create a `.env` file in the **root directory** and add your API key:
```sh
API_KEY=your_api_key_here
```
Make sure to add `.env` to your `.gitignore` file to prevent exposing your API key.

### 4️⃣ Run the App
```sh
flutter run
```

---

## 🏗 Project Structure
```
flutter-chatbot/
│── lib/                          # Main application directory
│   ├── main.dart                 # Entry point of the Flutter app
│   ├── api/                      
│   │   ├── gemini_api_service.dart  # Handles communication with Gemini AI API
│   ├── providers/                 
│   │   ├── chat_provider.dart     # Manages chatbot state and logic using Provider
│   ├── model/                     
│   │   ├── conversation.dart      # Defines Conversation model
│   │   ├── conversation.g.dart    # Auto-generated adapter for Hive database
│   │   ├── message.dart           # Defines Message model
│   │   ├── message.g.dart         # Auto-generated adapter for Hive database
│   ├── page/                      
│   │   ├── chat_page.dart         # UI for the chatbot conversation screen
│   ├── widgets/                    
│   │   ├── chat_bubble.dart       # UI component for chat messages
│   │   ├── chat_screen.dart       # Main chat UI layout
│── .env                           # Environment file storing API keys (excluded from Git)
│── pubspec.yaml                   # Defines dependencies, package metadata, and configurations
      
```
---

## 📦 Packages Used

The chatbot uses the following dependencies:

```yaml
google_generative_ai: ^0.4.6
provider: ^6.1.2
flutter_slider_drawer: ^3.0.2
flutter_markdown: ^0.7.6+2
image_picker: ^1.1.2
file_picker: ^8.0.0
hive: ^2.2.3
hive_flutter: ^1.1.0
path_provider: ^2.0.15
flutter_dotenv: ^5.2.1
flutter_markdown_selectionarea: ^0.6.17+1
```

---

## 🔗 API Integration
This chatbot communicates with Google's Gemini AI using the google_generative_ai package. The request format follows this approach:

```dart
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: dotenv.env['API_KEY']!,
);

Stream<String> sendMessageStream(
  String prompt, 
  List<Content> history, 
  {Uint8List? imageFile}
) async* {
  final List<Part> contentParts = [TextPart(prompt)];

  final chat = model.startChat(history: history);

  if (imageFile != null) {
    final image = DataPart('image/jpeg', imageFile);
    contentParts.add(image);
  }

  final responseStream = chat.sendMessageStream(Content.multi(contentParts));

  await for (final response in responseStream) {
    if (response.text != null) {
      yield response.text!;
    }
  }
}
```
Ensure your API key is stored in `.env` and **not hardcoded**.

Here's a separate README section to teach users how to generate a Gemini API key:

---

# 🌟 How to Generate a Gemini API Key

To use the chatbot, you need a **Gemini API key** from Google AI. Follow these steps:

### 1️⃣ Sign in to Google AI Studio
- Go to [Google AI Studio](https://aistudio.google.com/).
- Sign in with your **Google account**.

### 2️⃣ Create a New API Key
- Navigate to the **API Keys** section.
- Click **"Create API Key"**.
- Copy the generated **API key**.

### 3️⃣ Add API Key to Your Project
- Create a `.env` file in your project’s root directory.
- Paste your API key:
  ```sh
  API_KEY=your_generated_api_key
  ```
- **Important:** Do not share your API key publicly.

Now your chatbot can access the Gemini API! 🚀

---


## 📜 License
This project is licensed under the **MIT License**.

---

## ⭐ Contribute
Feel free to fork, open issues, or submit pull requests. Contributions are always welcome!

📩 **Follow & Star** this repo if you found it useful! 🚀



