# Ezcape

A modern, highly-responsive social event discovery application built with Flutter and Supabase. Ezcape allows users to create, discover, and join exciting "escapades" (events/activities) in their local area. 

## ✨ Features

*   **Robust Authentication:** Secure email, password, and session management powered by Supabase Auth, including complete password-reset flows.
*   **Event Creation & Discovery:** Users can craft custom escapades with cover photos, dates, locations, categories, and descriptions.
*   **Social Participation:** Users can join escapades and see dynamic, overlapping profile-picture widgets displaying who else is attending.
*   **Real-time Feeds:** Dedicated "Created by You" and "Joined" feeds utilizing Supabase's PostgreSQL arrays and JSON text queries, fully integrated with Flutter's `RefreshIndicator` for smooth pull-to-refresh UX.
*   **Media Storage:** Profile picture and event banner uploading/retrieval handled seamlessly via Supabase Storage.
*   **Declarative Navigation:** Deep routing, secure authentication gating, and context-free navigation managed by `go_router`.
*   **Responsive UI:** Pixel-perfect, scalable UI across all mobile devices using `flutter_screenutil`, custom SVG assets, and elegant gradient overlays.

---

## 🛠️ Tech Stack 

*   **Frontend Framework:** Flutter 
*   **Backend & Database:** Supabase (PostgreSQL)
*   **Authentication:** Supabase Auth
*   **Storage:** Supabase Storage
*   **Routing:** `go_router`
*   **State Management/Data Fetching:** Stateful Widgets & `FutureBuilder`
*   **Responsiveness:** `flutter_screenutil`
*   **Image Caching:** `cached_network_image` (suggested) / Native NetworkImage

---

## 🚀 Getting Started

To run this project locally, you will need to connect it to your own Supabase instance.

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/ezcape.git
cd ezcape
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Supabase
1. Create a new project on [Supabase](https://supabase.com).
2. Create the necessary tables (`user_interests`, `create_escapade`, `escapade_notifications`).
3. Setup a Storage bucket for images.

### 4. Configure Environment Variables
This project uses `--dart-define` to inject secure API keys at build time. You will need your Supabase URL and Anon Key.

To run the app:
```bash
flutter run --dart-define=SUPABASE_URL=YOUR_SUPABASE_URL --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

> **Note:** For convenience during development, you can create a `.env` file at the root of the project with these values. Ensure `.env` is added to your `.gitignore` to prevent leaking credentials!

---
<img width="308" height="621" alt="Screenshot 2026-03-10 at 23 32 07" src="https://github.com/user-attachments/assets/b6257f4f-ad91-4332-bdd6-dd6fcc9ba924"  />

<img width="308" height="621" alt="Screenshot 2026-03-10 at 23 30 42" src="https://github.com/user-attachments/assets/e7d58b20-015b-42c7-bfaa-de073dbc0a07"  />

<img width="308" height="621" alt="Screenshot 2026-03-10 at 23 30 58" src="https://github.com/user-attachments/assets/3fee06c9-bfc7-44d3-8bcc-df57adcc1718"  />

---

## 👨‍💻 Developer Notes
This app was built with a strong focus on modular architecture and clean UI/UX. The backend logic relies entirely on Supabase's secure API wrapper, removing the need for a custom Node.js/Python middleware backend.

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
