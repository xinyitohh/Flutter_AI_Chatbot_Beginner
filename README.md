# Flutter AI Chatbot for Beginner

A conversational AI chatbot built using **Flutter** and **Gemini AI** . 🚀

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
│── lib/
│   ├── main.dart         
│   ├── api/
│   │   ├── gemin_api_service.dart 
│   ├── providers/
│   │   ├── chat_provider.dart  
│   ├── model/
│   │   ├── conversation.dart  
│   │   ├── conversation.g.dart  
│   │   ├── message.dart  
│   │   ├── message.g.dart  
│   ├── page/
│   │   ├── chat_page.dart  
│   ├── widgets/
│   │   ├── chat_bubble.dart    
│   │   ├── chat_screen.dart    
│── .env                     
│── pubspec.yaml            
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
This chatbot communicates with an AI-based API. Update the `ChatProvider` to send requests:

```dart
final response = await http.post(
  Uri.parse('https://api.example.com/chat'),
  headers: {'Authorization': 'Bearer ${dotenv.env['API_KEY']}'},
  body: jsonEncode({'message': userInput}),
);
```
Ensure your API key is stored in `.env` and **not hardcoded**.

---


## 📜 License
This project is licensed under the **MIT License**.

---

## ⭐ Contribute
Feel free to fork, open issues, or submit pull requests. Contributions are always welcome!

📩 **Follow & Star** this repo if you found it useful! 🚀



