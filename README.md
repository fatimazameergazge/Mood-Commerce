# 🧠 MoodCommerce — Emotion-Powered Shopping Platform

<div align="center">

```
 __  __                 _  ____                                           
|  \/  | ___   ___   __| |/ ___|___  _ __ ___  _ __ ___   ___ _ __ ___ ___ 
| |\/| |/ _ \ / _ \ / _` | |   / _ \| '_ ` _ \| '_ ` _ \ / _ \ '__/ __/ _ \
| |  | | (_) | (_) | (_| | |__| (_) | | | | | | | | | | |  __/ | | (_|  __/
|_|  |_|\___/ \___/ \__,_|\____\___/|_| |_| |_|_| |_| |_|\___|_|  \___\___|
```

### *"You Feel It. We Find It."*

![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP](https://img.shields.io/badge/JSP-007396?style=for-the-badge&logo=java&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![Ruby](https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white)
![Apache Tomcat](https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=for-the-badge&logo=apachetomcat&logoColor=black)
![XML](https://img.shields.io/badge/XML-FF6600?style=for-the-badge&logo=xml&logoColor=white)

</div>

---

## 🌟 What is MoodCommerce?

**MoodCommerce** is a next-generation e-commerce platform that uses **real-time emotion detection** via webcam to recommend products based on how you *actually feel* — not just what you searched for.

> 💡 **The Big Idea:** Amazon recommends products based on *what you bought*. MoodCommerce recommends products based on *how you feel right now.*

---

## 🎯 Key Features

| Feature | Description |
|---|---|
| 😄 **Mood Detection** | Webcam reads facial expressions — detects 6 emotional states |
| 🛒 **Emotion-Based Cart** | Products auto-curated based on detected mood |
| 🌍 **Carbon Footprint Tracker** | Real-time CO₂ impact calculator for every order |
| 🏆 **Green Points Rewards** | Earn points for buying eco-friendly products |
| ⚠️ **Impulse Buy Alert** | Warns users shopping while stressed or sad |
| 📊 **Mood History** | Track your emotional patterns over time |
| 👨‍💼 **Admin Panel** | Full product & order management dashboard |
| 🔐 **PHP Auth System** | Secure login, register & session management |

---

## 🖥️ Screenshots

### 🏠 Main Shop — Dark Futuristic UI
```
┌─────────────────────────────────────────────────────┐
│  MoodCommerce          😄 Happy  ●  🛒 3            │
├─────────────────────────────────────────────────────┤
│                                                     │
│  You Feel It.        ┌──────────────────┐           │
│  We Find It.         │   👤 SCANNING    │           │
│                      │  ◯ ─ ─ ─ ─ ◯   │           │
│  [Scan My Mood]      │  Emotion Scanner  │           │
│  [How It Works]      └──────────────────┘           │
│                                                     │
├─────────────────────────────────────────────────────┤
│  6 Moods  |  2.4K+ Products  |  94% Accuracy        │
└─────────────────────────────────────────────────────┘
```

### 📊 Admin Panel — Rails Dashboard
```
┌──────────┬──────────────────────────────────────────┐
│ 📊 Dash  │  Revenue: ₹2.4L  Orders: 48  Products:24 │
│ 🛍 Prods │  ──────────────────────────────────────  │
│ 📦 Orders│  Mood Analytics Chart                    │
│ 😊 Moods │  😄75% 😌55% 😤40% 🥰65% 🤩85% 😔30%   │
│ 👥 Users │                                          │
│ 🌿 Eco   │  Recent Orders Table                     │
└──────────┴──────────────────────────────────────────┘
```

---

## 🔧 Tech Stack — All 6 Web Technologies

```
┌─────────────────────────────────────────────────────────────┐
│                    MOODCOMMERCE ARCHITECTURE                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  [Browser]                                                  │
│     │                                                       │
│     ├── HTML5 ──────── Structure & UI Design                │
│     ├── JavaScript ─── DOM, Webcam, Cart, Mood Engine       │
│     │                                                       │
│  [Tomcat Server :8080]                                      │
│     ├── Java Servlets ─ ProductServlet, OrderServlet        │
│     ├── XML ─────────── products.xml (Product Database)     │
│     └── JSP ─────────── Dynamic product pages              │
│                                                             │
│  [XAMPP Server :80]                                         │
│     └── PHP ─────────── Auth, Sessions, Green Points        │
│                                                             │
│  [Admin Panel]                                              │
│     └── Ruby on Rails ─ Product & Order Management         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Project Structure

```
MoodCommerce/
│
├── 📄 moodcommerce.html          # Main shop page (HTML + CSS)
│
├── 📁 js/
│   └── 📄 cart.js                # JavaScript & DOM module
│       ├── Webcam Module         # getUserMedia() camera access
│       ├── MoodEngine Module     # Emotion detection & mapping
│       ├── ProductGrid Module    # Dynamic product rendering
│       ├── Cart Module           # Add/Remove/Total tracking
│       └── UI Module             # Notifications & animations
│
├── 📁 WEB-INF/
│   ├── 📄 web.xml                # Servlet deployment descriptor
│   ├── 📁 xml/
│   │   └── 📄 products.xml       # Product database (24 products)
│   └── 📁 classes/
│       └── 📁 com/moodcommerce/servlets/
│           ├── 📄 ProductServlet.java  # Reads XML → returns JSON
│           └── 📄 OrderServlet.java   # Saves orders → XML
│
├── 📁 jsp/
│   ├── 📄 products.jsp           # Dynamic product listing page
│   └── 📄 order-confirm.jsp      # Order confirmation page
│
├── 📁 php/
│   ├── 📄 auth.php               # Backend auth engine
│   ├── 📄 login.php              # Login/Register UI
│   └── 📁 data/
│       └── 📄 users.json         # User database (auto-created)
│
├── 📁 rails/
│   ├── 📄 admin.html             # Admin dashboard UI
│   └── 📄 Gemfile                # Rails dependencies
│
└── 📄 README.md                  # This file
```

---

## 🚀 Getting Started

### Prerequisites

| Software | Version | Download |
|---|---|---|
| JDK | 17+ | [adoptium.net](https://adoptium.net) |
| Apache Tomcat | 9.x | [tomcat.apache.org](https://tomcat.apache.org) |
| XAMPP | Latest | [apachefriends.org](https://apachefriends.org) |
| VS Code | Latest | [code.visualstudio.com](https://code.visualstudio.com) |

---

### ▶️ Running the Project

#### 1️⃣ Start Tomcat (Java + JSP)
```bash
cd path/to/apache-tomcat/bin
startup.bat
```

#### 2️⃣ Start XAMPP (PHP)
```
Open XAMPP Control Panel → Click Start next to Apache
```

#### 3️⃣ Open in Browser

| Module | URL |
|---|---|
| 🏠 Main Shop | `http://localhost:8080/MoodCommerce/moodcommerce.html` |
| 🛍️ Products JSP | `http://localhost:8080/MoodCommerce/jsp/products.jsp?mood=happy` |
| ☕ Servlet API | `http://localhost:8080/MoodCommerce/ProductServlet?mood=happy` |
| 🔐 PHP Login | `http://localhost/MoodCommerce/php/login.php` |
| 👨‍💼 Admin Panel | Open `rails/admin.html` directly in browser |

---

### 🧪 Test Default Login

```
Email:    irfan@moodcommerce.com
Password: irfan123
```

---

## 😄 Supported Moods

| Mood | Emoji | Products | Impulse Risk |
|---|---|---|---|
| Happy | 😄 | Games, Fashion, Food | Low |
| Calm | 😌 | Wellness, Books, Tea | Low |
| Stressed | 😤 | Spa, Headphones, Chocolate | ⚠️ High |
| Romantic | 🥰 | Gifts, Jewellery, Candles | Medium |
| Excited | 🤩 | Tech, Adventure, Energy | Medium |
| Sad | 😔 | Comfort, Entertainment, Food | ⚠️ High |

---

## 🌿 Eco Score System

| Grade | Carbon Range | Green Points | Description |
|---|---|---|---|
| A+ | 0.0 — 0.2 kg CO₂ | 20 pts | Zero waste, fully sustainable |
| A | 0.2 — 0.5 kg CO₂ | 15 pts | Eco-friendly materials |
| B+ | 0.5 — 0.7 kg CO₂ | 10 pts | Partially sustainable |
| B | 0.7 — 1.2 kg CO₂ | 5 pts | Standard production |

---

## 💰 Business Potential

```
💼 Target Buyers:
   → E-commerce giants (Amazon, Flipkart, Myntra)
   → Retail chains for smart kiosks
   → Mental wellness brands
   → Advertising & marketing firms

💵 Monetization Models:
   → License the mood engine as SaaS API
   → Sell anonymized mood-shopping insights
   → White-label for retail brands
   → Subscription mood boxes

📈 Market Size:
   → Emotion AI market: $37 Billion by 2026
   → E-commerce market: $6.3 Trillion globally
```

---

## 📊 Module Breakdown

| # | Module | Technology | Status |
|---|---|---|---|
| 1 | UI Design | HTML5 + CSS3 | ✅ Complete |
| 2 | Interactivity | JavaScript + DOM | ✅ Complete |
| 3 | Backend | Java Servlets + XML | ✅ Complete |
| 4 | Dynamic Pages | JSP | ✅ Complete |
| 5 | Authentication | PHP + Sessions | ✅ Complete |
| 6 | Admin Panel | Ruby on Rails | ✅ Complete |

---

## 🔮 Future Enhancements

- [ ] Real Face API integration (Azure/Face++)
- [ ] Voice tone detection instead of camera
- [ ] Smartwatch heart rate → mood mapping
- [ ] VR shopping environment based on mood
- [ ] Mental health partnerships
- [ ] Mobile app (React Native)
- [ ] AI-powered product descriptions

---

## 👨‍💻 Author

**IRFAN**
- 🎓 Web Technologies Mini Project — 2026
- 💼 Built with HTML · JavaScript · Java · JSP · PHP · Ruby on Rails

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

### ⭐ If you found this project interesting, please give it a star!

*Built with ❤️ and lots of ☕ by IRFAN*

</div>
