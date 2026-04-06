// ============================================================
//  MoodCommerce — cart.js
//  JavaScript & DOM Module
//  Handles: Webcam, Mood Detection, Cart, Carbon, Green Points
// ============================================================

"use strict";

// ─── STATE ───────────────────────────────────────────────────
const STATE = {
  mood: "default",
  cartItems: [],
  carbon: 0,
  greenPoints: 0,
  scanning: false,
  scanInterval: null,
  moodHistory: [],
  totalSpend: 0,
};

// ─── MOOD CONFIG ──────────────────────────────────────────────
const MOODS = {
  happy:    { emoji: "😄", color: "#facc15", glow: "rgba(250,204,21,0.12)",  label: "Happy",    impulse: false },
  calm:     { emoji: "😌", color: "#60a5fa", glow: "rgba(96,165,250,0.12)",  label: "Calm",     impulse: false },
  stressed: { emoji: "😤", color: "#f87171", glow: "rgba(248,113,113,0.12)", label: "Stressed", impulse: true  },
  romantic: { emoji: "🥰", color: "#a78bfa", glow: "rgba(167,139,250,0.12)", label: "Romantic", impulse: false },
  excited:  { emoji: "🤩", color: "#fb923c", glow: "rgba(251,146,60,0.12)",  label: "Excited",  impulse: true  },
  sad:      { emoji: "😔", color: "#94a3b8", glow: "rgba(148,163,184,0.12)", label: "Sad",      impulse: true  },
};

// ─── PRODUCTS DB ──────────────────────────────────────────────
const PRODUCTS = {
  happy: [
    { id:"h1", emoji:"🎮", cat:"Gaming",    name:"Pro Controller X1",   price:3499, eco:"A+", carbon:0.3 },
    { id:"h2", emoji:"🎧", cat:"Audio",     name:"Party Buds Max",      price:1999, eco:"B",  carbon:0.6 },
    { id:"h3", emoji:"👟", cat:"Fashion",   name:"Neon Kicks 2.0",      price:5299, eco:"A",  carbon:0.5 },
    { id:"h4", emoji:"🧃", cat:"Food",      name:"Happy Juice Bundle",  price:799,  eco:"A+", carbon:0.1 },
  ],
  calm: [
    { id:"c1", emoji:"🕯️", cat:"Wellness",  name:"Aura Candle Set",     price:899,  eco:"A+", carbon:0.1 },
    { id:"c2", emoji:"📖", cat:"Books",     name:"Mindful Living Vol.2",price:449,  eco:"A+", carbon:0.05},
    { id:"c3", emoji:"🧘", cat:"Fitness",   name:"Zen Yoga Mat Pro",    price:1299, eco:"A",  carbon:0.4 },
    { id:"c4", emoji:"🍵", cat:"Beverage",  name:"Calm Brew Tea Kit",   price:649,  eco:"A+", carbon:0.1 },
  ],
  stressed: [
    { id:"s1", emoji:"💆", cat:"Self-Care", name:"De-Stress Spa Kit",   price:1499, eco:"A",  carbon:0.3 },
    { id:"s2", emoji:"🎵", cat:"Audio",     name:"Noise Cancel Pro",    price:7999, eco:"B+", carbon:0.7 },
    { id:"s3", emoji:"🍫", cat:"Food",      name:"Dark Choco Relief Box",price:599, eco:"A",  carbon:0.2 },
    { id:"s4", emoji:"🛁", cat:"Wellness",  name:"Epsom Salt Bundle",   price:399,  eco:"A+", carbon:0.1 },
  ],
  romantic: [
    { id:"r1", emoji:"🌹", cat:"Gift",      name:"Eternal Rose Box",    price:2199, eco:"A",  carbon:0.4 },
    { id:"r2", emoji:"💍", cat:"Jewellery", name:"Silver Charm Set",    price:3799, eco:"B+", carbon:0.6 },
    { id:"r3", emoji:"🕯️", cat:"Ambience",  name:"Couple Candle Kit",   price:999,  eco:"A+", carbon:0.1 },
    { id:"r4", emoji:"🍷", cat:"Beverage",  name:"Premium Wine Pairing",price:1899, eco:"B",  carbon:0.5 },
  ],
  excited: [
    { id:"e1", emoji:"🚀", cat:"Tech",      name:"Drone Mini Explorer", price:8999, eco:"B",  carbon:0.9 },
    { id:"e2", emoji:"🎢", cat:"Experience",name:"Adventure Pass",      price:2499, eco:"A",  carbon:0.2 },
    { id:"e3", emoji:"⚡", cat:"Energy",    name:"Pre-Workout Blast",   price:1199, eco:"B+", carbon:0.4 },
    { id:"e4", emoji:"🕹️", cat:"Gaming",    name:"VR Headset Lite",     price:12999,eco:"B",  carbon:1.1 },
  ],
  sad: [
    { id:"d1", emoji:"🧸", cat:"Comfort",   name:"Cozy Plush Bundle",   price:1299, eco:"A",  carbon:0.3 },
    { id:"d2", emoji:"🎬", cat:"Entertainment",name:"OTT 3-Month Pass", price:699,  eco:"A+", carbon:0.05},
    { id:"d3", emoji:"🍕", cat:"Food",      name:"Comfort Food Box",    price:899,  eco:"B",  carbon:0.6 },
    { id:"d4", emoji:"📔", cat:"Wellness",  name:"Gratitude Journal",   price:349,  eco:"A+", carbon:0.05},
  ],
  default: [
    { id:"x1", emoji:"✨", cat:"Trending",  name:"Smart Water Bottle",  price:1499, eco:"A+", carbon:0.2 },
    { id:"x2", emoji:"🎒", cat:"Lifestyle", name:"Urban Backpack Pro",  price:2999, eco:"A",  carbon:0.5 },
    { id:"x3", emoji:"💡", cat:"Smart Home",name:"LED Strip RGB Kit",   price:799,  eco:"B+", carbon:0.4 },
    { id:"x4", emoji:"🌿", cat:"Wellness",  name:"Plant Care Starter",  price:599,  eco:"A+", carbon:0.1 },
  ],
};

// ─── WEBCAM MODULE ────────────────────────────────────────────
const Webcam = {
  stream: null,
  videoEl: null,

  async start() {
    try {
      this.stream = await navigator.mediaDevices.getUserMedia({
        video: { width: 320, height: 240, facingMode: "user" },
        audio: false,
      });
      this.videoEl = document.getElementById("camVideo");
      if (this.videoEl) {
        this.videoEl.srcObject = this.stream;
        this.videoEl.play();
      }
      UI.setCamStatus("[ live feed active ]");
      UI.showNotification("📷 Camera connected successfully!", "success");
      return true;
    } catch (err) {
      UI.setCamStatus("[ camera access denied ]");
      UI.showNotification("⚠ Camera blocked — using manual mood selection.", "warn");
      return false;
    }
  },

  stop() {
    if (this.stream) {
      this.stream.getTracks().forEach((t) => t.stop());
      this.stream = null;
    }
  },
};

// ─── MOOD ENGINE ──────────────────────────────────────────────
const MoodEngine = {
  // Simulated AI detection — in production replace with Face API call
  simulateScan() {
    const sequence = [
      { status: "[ initializing AI model... ]",   delay: 0    },
      { status: "[ detecting face landmarks... ]", delay: 900  },
      { status: "[ analysing micro-expressions... ]", delay: 1800 },
      { status: "[ computing emotion vector... ]", delay: 2700 },
      { status: "[ cross-referencing mood DB... ]", delay: 3400 },
    ];
    sequence.forEach(({ status, delay }) => {
      setTimeout(() => UI.setCamStatus(status), delay);
    });
    setTimeout(() => {
      const keys = Object.keys(MOODS);
      const detected = keys[Math.floor(Math.random() * keys.length)];
      const confidence = (82 + Math.random() * 17).toFixed(1);
      const moodIdx   = (0.65 + Math.random() * 0.34).toFixed(3);
      MoodEngine.applyMood(detected, confidence, moodIdx);
      STATE.scanning = false;
      document.getElementById("scanBtn").textContent = "Scan My Mood";
      document.getElementById("scanBtn").disabled = false;
    }, 4200);
  },

  applyMood(moodKey, confidence = "—", moodIdx = "—") {
    const prev = STATE.mood;
    STATE.mood = moodKey;
    STATE.moodHistory.push({ mood: moodKey, time: new Date().toLocaleTimeString() });

    const cfg = MOODS[moodKey];
    document.documentElement.style.setProperty("--mood-color", cfg.color);
    document.documentElement.style.setProperty("--mood-glow", cfg.glow);

    // Pill
    document.getElementById("moodPillLabel").textContent = cfg.label;
    document.getElementById("moodDot").style.background = cfg.color;

    // Data tags
    document.getElementById("confVal").textContent  = confidence !== "—" ? confidence + "%" : "—";
    document.getElementById("moodIdx").textContent  = moodIdx;

    // Cam status
    UI.setCamStatus(`[ ${cfg.label.toLowerCase()} detected · ${confidence}% ]`);

    // Glow bg
    document.getElementById("moodGlow").style.background =
      `radial-gradient(circle, ${cfg.glow} 0%, transparent 70%)`;

    // Highlight mood card
    document.querySelectorAll(".mood-card").forEach((c) => {
      c.classList.toggle("active", c.dataset.mood === moodKey);
    });

    // Update product title
    const titles = {
      happy:    "😄 Happy Picks For You",
      calm:     "😌 Calm & Collected Finds",
      stressed: "💆 Stress-Relief Essentials",
      romantic: "🥰 Romance Collection",
      excited:  "🤩 High Energy Picks",
      sad:      "🧸 Comfort & Care Picks",
      default:  "✨ Top Picks Right Now",
    };
    document.getElementById("productTitle").textContent = titles[moodKey] || titles.default;

    // Render products
    ProductGrid.render(moodKey);

    // Impulse warning
    if (MOODS[moodKey]?.impulse) {
      document.getElementById("impulseWarn").style.display = "block";
    } else {
      document.getElementById("impulseWarn").style.display = "none";
    }

    if (prev !== moodKey) {
      UI.showNotification(`${cfg.emoji} Mood detected: ${cfg.label} — products updated!`, "mood");
    }

    // Update history panel
    UI.renderMoodHistory();
  },
};

// ─── PRODUCT GRID ─────────────────────────────────────────────
const ProductGrid = {
  activeFilter: "All",

  render(mood) {
    const grid = document.getElementById("productsGrid");
    const products = PRODUCTS[mood] || PRODUCTS.default;
    grid.innerHTML = "";
    products.forEach((p, i) => {
      const card = document.createElement("div");
      card.className = "product-card";
      card.style.animationDelay = `${i * 0.08}s`;
      card.innerHTML = `
        <div class="product-img">
          <span class="prod-emoji">${p.emoji}</span>
          <div class="eco-badge">Eco ${p.eco}</div>
          <div class="mood-match">Match <span>${85 + Math.floor(Math.random()*14)}%</span></div>
        </div>
        <div class="product-info">
          <div class="product-cat">${p.cat}</div>
          <div class="product-name">${p.name}</div>
          <div class="product-footer">
            <div class="product-price">₹${p.price.toLocaleString("en-IN")}</div>
            <button class="add-btn" data-id="${p.id}">+ Add</button>
          </div>
        </div>`;
      card.querySelector(".add-btn").addEventListener("click", () => Cart.add(p));
      grid.appendChild(card);
    });
  },
};

// ─── CART MODULE ──────────────────────────────────────────────
const Cart = {
  add(product) {
    // Impulse buy check
    if (MOODS[STATE.mood]?.impulse) {
      UI.showImpulseAlert();
    }

    const existing = STATE.cartItems.find((i) => i.id === product.id);
    if (existing) {
      existing.qty++;
    } else {
      STATE.cartItems.push({ ...product, qty: 1 });
    }

    STATE.totalSpend += product.price;
    STATE.carbon     += product.carbon;

    // Green points: A+ = 20, A = 15, B+ = 10, B = 5
    const pts = { "A+": 20, A: 15, "B+": 10, B: 5 };
    STATE.greenPoints += pts[product.eco] || 5;

    this.updateUI();
    UI.showNotification(`🛒 ${product.name} added to cart!`, "success");

    // Cart bounce animation
    const countEl = document.getElementById("cartCount");
    countEl.classList.remove("bounce");
    void countEl.offsetWidth;
    countEl.classList.add("bounce");
  },

  remove(productId) {
    const idx = STATE.cartItems.findIndex((i) => i.id === productId);
    if (idx === -1) return;
    const item = STATE.cartItems[idx];
    STATE.carbon      = Math.max(0, STATE.carbon - item.carbon * item.qty);
    STATE.greenPoints = Math.max(0, STATE.greenPoints - (item.qty * 10));
    STATE.totalSpend  = Math.max(0, STATE.totalSpend - item.price * item.qty);
    STATE.cartItems.splice(idx, 1);
    this.updateUI();
    this.renderPanel();
  },

  updateUI() {
    const total = STATE.cartItems.reduce((s, i) => s + i.qty, 0);
    document.getElementById("cartCount").textContent = total;

    // Carbon
    document.getElementById("carbonVal").textContent = STATE.carbon.toFixed(2) + " kg CO₂";
    const pct = Math.min(STATE.carbon * 8, 100);
    document.getElementById("carbonFill").style.width = pct + "%";

    // Green points
    document.getElementById("greenPts").textContent = STATE.greenPoints + " pts";

    // Cart panel
    this.renderPanel();
  },

  renderPanel() {
    const list = document.getElementById("cartList");
    if (!list) return;
    if (STATE.cartItems.length === 0) {
      list.innerHTML = `<div class="cart-empty">Your cart is empty</div>`;
      document.getElementById("cartTotal").textContent = "₹0";
      return;
    }
    list.innerHTML = STATE.cartItems.map((item) => `
      <div class="cart-item">
        <span class="cart-item-emoji">${item.emoji}</span>
        <div class="cart-item-info">
          <div class="cart-item-name">${item.name}</div>
          <div class="cart-item-price">₹${(item.price * item.qty).toLocaleString("en-IN")} × ${item.qty}</div>
        </div>
        <button class="cart-remove" data-id="${item.id}">✕</button>
      </div>`).join("");
    list.querySelectorAll(".cart-remove").forEach((btn) => {
      btn.addEventListener("click", () => Cart.remove(btn.dataset.id));
    });
    document.getElementById("cartTotal").textContent =
      "₹" + STATE.totalSpend.toLocaleString("en-IN");
  },

  toggle() {
    const panel = document.getElementById("cartPanel");
    panel.classList.toggle("open");
    this.renderPanel();
  },
};

// ─── UI MODULE ────────────────────────────────────────────────
const UI = {
  setCamStatus(msg) {
    const el = document.getElementById("camStatus");
    if (el) el.textContent = msg;
  },

  showNotification(msg, type = "info") {
    const container = document.getElementById("notifications");
    const n = document.createElement("div");
    n.className = `notif notif-${type}`;
    n.textContent = msg;
    container.appendChild(n);
    requestAnimationFrame(() => n.classList.add("show"));
    setTimeout(() => {
      n.classList.remove("show");
      setTimeout(() => n.remove(), 400);
    }, 3000);
  },

  showImpulseAlert() {
    const popup = document.getElementById("alertPopup");
    popup.classList.add("show");
    setTimeout(() => popup.classList.remove("show"), 5000);
    document.getElementById("impulseWarn").style.display = "block";
  },

  renderMoodHistory() {
    const el = document.getElementById("moodHistoryList");
    if (!el) return;
    const last5 = STATE.moodHistory.slice(-5).reverse();
    el.innerHTML = last5.map((h) => `
      <div class="history-item">
        <span>${MOODS[h.mood]?.emoji || "❓"}</span>
        <span class="history-mood">${h.mood}</span>
        <span class="history-time">${h.time}</span>
      </div>`).join("") || "<div class='history-empty'>No scans yet</div>";
  },
};

// ─── DOM SETUP ────────────────────────────────────────────────
document.addEventListener("DOMContentLoaded", () => {

  // Mood card clicks
  document.querySelectorAll(".mood-card").forEach((card) => {
    card.addEventListener("click", () => {
      MoodEngine.applyMood(card.dataset.mood);
    });
  });

  // Scan button
  const scanBtn = document.getElementById("scanBtn");
  if (scanBtn) {
    scanBtn.addEventListener("click", async () => {
      if (STATE.scanning) return;
      STATE.scanning = true;
      scanBtn.textContent = "Scanning...";
      scanBtn.disabled = true;
      const camOk = await Webcam.start();
      MoodEngine.simulateScan();
    });
  }

  // Cart toggle
  const cartBtn = document.getElementById("cartToggleBtn");
  if (cartBtn) cartBtn.addEventListener("click", () => Cart.toggle());

  const cartClose = document.getElementById("cartClose");
  if (cartClose) cartClose.addEventListener("click", () => Cart.toggle());

  // Filter buttons
  document.querySelectorAll(".filter-btn").forEach((btn) => {
    btn.addEventListener("click", function () {
      document.querySelectorAll(".filter-btn").forEach((b) => b.classList.remove("active"));
      this.classList.add("active");
      ProductGrid.activeFilter = this.textContent;
    });
  });

  // Custom cursor
  const cursor = document.getElementById("cursor");
  const ring   = document.getElementById("cursor-ring");
  if (cursor && ring) {
    document.addEventListener("mousemove", (e) => {
      cursor.style.left = e.clientX - 6 + "px";
      cursor.style.top  = e.clientY - 6 + "px";
      ring.style.left   = e.clientX - 18 + "px";
      ring.style.top    = e.clientY - 18 + "px";
    });
    document.querySelectorAll("button, a, .mood-card, .product-card").forEach((el) => {
      el.addEventListener("mouseenter", () => {
        cursor.style.transform = "scale(2)";
        ring.style.transform   = "scale(1.5)";
      });
      el.addEventListener("mouseleave", () => {
        cursor.style.transform = "scale(1)";
        ring.style.transform   = "scale(1)";
      });
    });
  }

  // Initial render
  ProductGrid.render("default");
  Cart.updateUI();

  console.log("%c MoodCommerce JS Loaded ✓", "color:#00f5c4;font-size:14px;font-weight:bold;");
});
