<div align="center">
  <img src="assets/icons/app-icon.png" width="120" alt="SpendoraIQ Logo">
  <h1>SpendoraIQ</h1>
  <p>A beautiful, completely offline, and customizable personal finance tracker built with Flutter.</p>
</div>

---

## 🚀 Overview

**SpendoraIQ** is a fast, responsive, and privacy-focused personal finance application. Track your daily expenses, set category-based budgets, and analyze your financial habits with rich interactive charts—all without your data ever leaving your device.

## ✨ Key Features

- **💸 Transaction Management**: Add, edit, delete, and categorize your income and expenses effortlessly.
- **🏷️ Custom Categories**: Create unlimited custom categories. Pick from a curated list of vibrant colors and elegant Material icons to match your style.
- **📊 Interactive Analytics**: Visualize your spending habits through beautiful, interactive pie charts and lists.
- **💼 Smart Budgeting**: Set monthly budgets for specific categories. Track your progress with visual indicators that turn red when you overspend.
- **🔒 100% Offline & Private**: All data is stored locally on your device using `SharedPreferences`. No cloud, no tracking, complete privacy.
- **🎨 Material 3 Design**: Supports automatic Light & Dark modes, sleek typography (Google Fonts), and smooth micro-animations.
- **💱 Multi-Currency**: Switch between your preferred currencies directly from the settings.
- **📤 Data Export**: Easily export your entire financial history as a JSON file for safekeeping.

---

## 📸 Screenshots

*(Replace with actual screenshots of your application)*
<div align="center">
  <img src="https://via.placeholder.com/250x500?text=Dashboard" width="200" alt="Dashboard Screen">
  <img src="https://via.placeholder.com/250x500?text=Analytics" width="200" alt="Analytics Screen">
  <img src="https://via.placeholder.com/250x500?text=Custom+Categories" width="200" alt="Categories Screen">
  <img src="https://via.placeholder.com/250x500?text=Budgets" width="200" alt="Budgets Screen">
</div>

---

## 🛠️ Tech Stack & Packages

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: `provider`
- **Local Storage**: `shared_preferences`
- **Charts**: `fl_chart`
- **UI Components**: `flutter_slidable`, `google_fonts`, `fluttertoast`
- **Utilities**: `intl`, `uuid`

---

## 📁 Project Structure

```text
lib/
├── core/
│   └── utils/         # Helper functions (Date formatting, Toast util)
├── data/
│   ├── local/         # SharedPreferences helper, JSON Export service
│   └── models/        # Data structures (ExpenseModel, BudgetModel, CategoryModel)
├── providers/         # State management (ExpenseProvider, SettingsProvider)
├── ui/
│   ├── screens/       # Application pages (Dashboard, Analytics, Manage Categories, etc.)
│   └── widgets/       # Reusable UI components (ExpenseTile, BudgetCard)
└── main.dart          # Application entry point
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio, VS Code, or Xcode

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/spendoraiq.git
   cd spendoraiq
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/yourusername/spendoraiq/issues). 

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
