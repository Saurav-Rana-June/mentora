# Mentora AI Chat Feature Documentation

This document explains the features, user interface design, state management, and custom rendering logic implemented in the **Mentora AI Chat** module (`lib/presentation/chatAI/`).

---

## 🌌 Overview

The AI Chat screen ([`chat_a_i.screen.dart`](file:///c:/work/MyPersonal/Mentora_FS/mentora/lib/presentation/chatAI/chat_a_i.screen.dart)) serves as a dedicated, private, and secure conversation interface where users can discuss mental health, anxiety, and wellness topics with **Mentora AI**. It features a premium, futuristic dark-theme interface with custom canvas background animations, pre-configured mental health suggestions, multi-session conversation history, screen sharing capabilities, and active scroll indicators.

---

## 🛠️ Key Technical Architecture & State Management

- **GetX Architecture**: Follows clean MVVM separation of concerns. The screen extends `GetView<ChatAIController>`, leveraging [`ChatAIController`](file:///c:/work/MyPersonal/Mentora_FS/mentora/lib/presentation/chatAI/controllers/chat_a_i.controller.dart) to govern state variables, sessions, message inputs, custom scrolling logic, and image exporting.
- **Local Multi-Session Persistence**: Automatically saves chat sessions and message threads to `GetStorage` via `StorageUtils`.
- **Dark Theme Forced Mode**: The root of the build method wraps the interface in a custom `Theme` set to `AppTheme.darkTheme` to guarantee a consistent immersive styling experience irrespective of system settings.
- **RepaintBoundary Optimization**: Wrapped inside `RepaintBoundary` to capture high-definition context screenshots on-demand without recalculating layouts.

---

## 🌟 Visual & Layout Features

### 1. 🧬 Animated Aurora Particle Background (`_FuturisticBackground`)
- Utilizes a `CustomPaint` widget driven by an `AnimationController` ticking continuously across a 25-second interval.
- **Aurora Shader effect**: The custom painter `_AuroraBackgroundPainter` draws primary accent radial gradients representing glowing energy nodes.
- **Connected Particle Web**: Animates six particle nodes shifting dynamically on screen. Lines are drawn between nodes whose distance falls below a preset threshold, generating a fluid constellation/neural network effect.

### 2. 🏡 Landing state & Greetings view
When the message history list is empty, a welcoming onboarding dashboard is displayed:
- **Branded Greeting**: Houses the official Mentora logo alongside supportive instructions ("Your safe space for mental well-being").
- **Quick Input Card**: A clean, centralized text box supporting multiline inputs and keyboard submission.
- **Recent Conversations Quick Carousel**: If the user has prior saved chat sessions, a horizontal list appears allowing quick one-tap resumption.

### 3. 🏷️ Mindfulness Suggestion Chips
Directly beneath the onboarding box is a horizontally scrollable list containing four quick-tap action cards:
| Title | Description | Sparked AI Prompt Query |
| :--- | :--- | :--- |
| **Feeling Anxious** | Calm your mind and body with guided relaxation | *"I'm feeling really anxious right now. Can you help me calm down?"* |
| **Breathing Exercise** | Quick 2-minute deep breathing session | *"Could we do a quick breathing exercise together to relax?"* |
| **Stress Relief** | Manage stress, anxiety, and pressure effectively | *"I have a lot of stress lately and feel overwhelmed. How should I handle it?"* |
| **Mindfulness Quote** | Get daily quote inspiration and reflection | *"Give me a mindfulness quote and help me journal about my day."* |

---

## 💬 Conversation & Interaction Flows

### 1. 💬 Chat Bubble Styles
Messages are reactive (`RxList<MessageModel>`) and sorted in a standard ListView:
- **User Messages**: Aligned to the right, colored in primary brand purple with asymmetric rounded borders (bottom-right edge remains square).
- **AI responses**: Aligned to the left, styled in card surface background colors, prefaced by a glowing sparkle/stars icon. Rendered via Markdown (`flutter_markdown`).

### 2. 🌁 Glassmorphic Title Bar
- The custom app bar (`CustomPrimaryAppBar`) monitors active list scroll position (`isScrolled.value`).
- Displays session title when chatting or "Mentora AI" with real-time status indicator.
- Contains direct action buttons for **Chat History** (`\u{f1da}`) and **New Chat** (`\u{f044}`).

### 3. 📜 Chat History BottomSheet (`ChatHistoryBottomsheet`)
- **Filterable Search**: Filter previous chats in real-time by keywords or title.
- **Session Cards**: Displays session title, last message preview, message count badge, formatted timestamp, and active indicator.
- **Session Management**: Switch between conversations, delete individual chats, or clear all history with confirmation.
- **New Chat Quick Action**: Floating/header button to immediately initiate a fresh conversation.

---

## ⚙️ Options Action Dropdown

Tapping the profile avatar button exposes a dropdown menu:
1. **New Chat**: Starts a new conversation thread.
2. **Chat History**: Opens the conversation history bottomsheet.
3. **Search**: Activates the appbar search box overlay.
4. **Export Chat**: Converts `RepaintBoundary` to high-resolution PNG and opens native share sheet.
5. **Clear Chat**: Deletes the current chat session after user confirmation.
