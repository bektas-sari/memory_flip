# Memory Flip – Fun & Educational Memory Card Game

## 📌 Description

**Memory Flip** is a simple yet engaging memory card game designed for children to improve their **visual memory** and **concentration skills**. Built with **Flutter**, the game features a modern and colorful interface with smooth animations. Players flip cards to find matching pairs, tracking their moves and aiming to complete the board with the fewest attempts.

---

## 🎯 Features

* **4x4 Grid** with 8 unique emoji pairs (can be easily customized)
* **Flip Animation** using `AnimatedSwitcher` and 3D rotation effect
* **Move Counter** to encourage better performance
* **Responsive Layout** for mobile and web platforms
* **Colorful Gradient Background** for an engaging look
* **Restart Option** for quick replay
* **Victory Dialog** with total moves summary
* Built using **pure Flutter widgets** (no external UI packages)

---

## 🛠️ Tech Stack

* **Framework:** Flutter (Dart)
* **UI Components:** Material Design 3, AnimatedSwitcher, LayoutBuilder
* **Supported Platforms:** Android, iOS, Web, Desktop

---

## 📂 Project Structure

```
lib/
  main.dart                # Main application file with game logic and UI
```

---

## 🚀 Getting Started

### 1️⃣ Prerequisites

* Install [Flutter SDK](https://flutter.dev/docs/get-started/install)
* Install an editor like [Visual Studio Code](https://code.visualstudio.com/) or Android Studio

### 2️⃣ Installation

```bash
git clone https://github.com/bektas-sari/memory_flip.git
cd memory_flip
flutter pub get
```

### 3️⃣ Run the App

#### For Mobile (Android/iOS)

```bash
flutter run
```

#### For Web

```bash
flutter run -d chrome
```

---

## 🎮 How to Play

1. Tap a card to reveal the emoji.
2. Tap another card to find its matching pair.
3. If they match, they remain face-up; otherwise, they flip back down.
4. Continue until all pairs are matched.
5. Try to complete the game in the fewest moves possible!

---

## 📸 Screenshots

*(Add screenshots here once available)*

---

## 🧩 Customization

* Change emojis in `base` list inside `main.dart`.
* Adjust grid size by modifying the `SliverGridDelegateWithFixedCrossAxisCount` value.
* Update colors in `_FancyBackground` for a new theme.

---

## 👤 Developer

**Bektas Sari**
Email: [bektas.sari@gmail.com](mailto:bektas.sari@gmail.com)
GitHub: [https://github.com/bektas-sari](https://github.com/bektas-sari)
LinkedIn: [www.linkedin.com/in/bektas-sari](https://www.linkedin.com/in/bektas-sari)
ResearchGate: [https://www.researchgate.net/profile/Bektas-Sari-3](https://www.researchgate.net/profile/Bektas-Sari-3)
Academia: [https://independent.academia.edu/bektassari](https://independent.academia.edu/bektassari)
ORCID: [0000-0001-7290-121X](https://orcid.org/0000-0001-7290-121X)

---

## 📄 License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

---

## 💡 Future Improvements

* Add **difficulty levels** (2x2, 3x4, 4x4)
* Implement **best score tracking** using `shared_preferences`
* Add **sound effects** for match/mismatch events
* Include **custom themes** for more engaging gameplay
