<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
    MoodCommerce — order-confirm.jsp
    Shows order confirmation after checkout
    URL: /MoodCommerce/order-confirm.jsp?orderId=ORD-xxx&name=xxx&mood=xxx
--%>
<%
    String orderId   = request.getParameter("orderId");
    String name      = request.getParameter("name");
    String mood      = request.getParameter("mood");
    String total     = request.getParameter("total");
    String greenPts  = request.getParameter("greenPts");

    if(orderId == null)  orderId  = "ORD-" + System.currentTimeMillis();
    if(name == null)     name     = "Guest";
    if(mood == null)     mood     = "happy";
    if(total == null)    total    = "0";
    if(greenPts == null) greenPts = "0";

    String moodEmoji = "😊";
    String moodMsg   = "Happy shopping!";
    switch(mood) {
        case "happy":    moodEmoji = "😄"; moodMsg = "Keep smiling! Great picks!";         break;
        case "calm":     moodEmoji = "😌"; moodMsg = "Peaceful choices, peaceful mind.";   break;
        case "stressed": moodEmoji = "💆"; moodMsg = "Take it easy. Relief is on the way!"; break;
        case "romantic": moodEmoji = "🥰"; moodMsg = "Love is in the air!";                break;
        case "excited":  moodEmoji = "🤩"; moodMsg = "Amazing energy! Great picks!";       break;
        case "sad":      moodEmoji = "🧸"; moodMsg = "We hope this cheers you up!";        break;
    }

    // Format timestamp
    java.time.LocalDateTime now = java.time.LocalDateTime.now();
    String timestamp = now.format(java.time.format.DateTimeFormatter.ofPattern("dd MMM yyyy, hh:mm a"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>MoodCommerce — Order Confirmed! 🎉</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;700;800&family=DM+Mono:wght@300;500&family=Fraunces:ital,wght@1,300&display=swap" rel="stylesheet"/>
  <style>
    :root { --bg:#060810; --card:#111827; --border:#1f2937; --accent:#00f5c4; --text:#f0f4ff; --muted:#6b7280; }
    *,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
    body { background:var(--bg); color:var(--text); font-family:'DM Mono',monospace; min-height:100vh; display:flex; flex-direction:column; align-items:center; justify-content:center; padding:2rem; }
    body::after { content:''; position:fixed; inset:0; background-image:linear-gradient(rgba(0,245,196,0.03) 1px,transparent 1px),linear-gradient(90deg,rgba(0,245,196,0.03) 1px,transparent 1px); background-size:48px 48px; pointer-events:none; z-index:0; }

    .confirm-box { background:var(--card); border:1px solid var(--border); max-width:600px; width:100%; position:relative; z-index:1; overflow:hidden; }

    /* Top Success Bar */
    .success-bar { background:rgba(0,245,196,0.1); border-bottom:1px solid var(--accent); padding:2rem; text-align:center; }
    .success-icon { font-size:4rem; margin-bottom:1rem; display:block; animation:popIn 0.5s ease; }
    @keyframes popIn { from{transform:scale(0)} to{transform:scale(1)} }
    .success-title { font-family:'Syne',sans-serif; font-size:2rem; font-weight:800; color:var(--accent); letter-spacing:-0.02em; }
    .success-sub { font-family:'Fraunces',serif; font-style:italic; font-size:1rem; color:var(--muted); margin-top:0.3rem; }

    /* Order Details */
    .order-details { padding:2rem; }
    .detail-label { font-size:0.6rem; letter-spacing:0.2em; text-transform:uppercase; color:var(--accent); margin-bottom:1.5rem; }

    .detail-row { display:flex; justify-content:space-between; align-items:center; padding:0.8rem 0; border-bottom:1px solid var(--border); }
    .detail-row:last-child { border-bottom:none; }
    .detail-key { font-size:0.65rem; color:var(--muted); text-transform:uppercase; letter-spacing:0.1em; }
    .detail-val { font-size:0.8rem; color:var(--text); }
    .detail-val.accent { color:var(--accent); font-family:'Syne',sans-serif; font-size:1rem; font-weight:700; }

    /* Mood Message */
    .mood-message { margin:1.5rem 2rem; padding:1rem 1.5rem; border:1px solid var(--border); background:rgba(255,255,255,0.02); text-align:center; }
    .mood-msg-emoji { font-size:2rem; display:block; margin-bottom:0.5rem; }
    .mood-msg-text { font-size:0.72rem; color:var(--muted); line-height:1.6; }

    /* Stats Row */
    .stats-row { display:grid; grid-template-columns:repeat(3,1fr); border-top:1px solid var(--border); }
    .stat-box { padding:1.2rem; text-align:center; border-right:1px solid var(--border); }
    .stat-box:last-child { border-right:none; }
    .stat-num { font-family:'Syne',sans-serif; font-size:1.5rem; font-weight:800; color:var(--accent); }
    .stat-label { font-size:0.55rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--muted); margin-top:0.2rem; }

    /* Actions */
    .actions { padding:1.5rem 2rem; display:flex; gap:1rem; border-top:1px solid var(--border); }
    .btn-primary { flex:1; background:var(--accent); color:#000; font-family:'DM Mono',monospace; font-size:0.72rem; font-weight:500; letter-spacing:0.1em; text-transform:uppercase; padding:0.9rem; border:none; cursor:pointer; text-align:center; text-decoration:none; display:block; transition:opacity 0.2s; }
    .btn-primary:hover { opacity:0.85; }
    .btn-ghost { flex:1; background:none; color:var(--muted); font-family:'DM Mono',monospace; font-size:0.72rem; letter-spacing:0.1em; text-transform:uppercase; padding:0.9rem; border:1px solid var(--border); cursor:pointer; text-align:center; text-decoration:none; display:block; transition:all 0.2s; }
    .btn-ghost:hover { color:var(--text); border-color:var(--text); }

    .footer-note { margin-top:1.5rem; font-size:0.6rem; color:var(--muted); text-align:center; position:relative; z-index:1; }
  </style>
</head>
<body>

  <div class="confirm-box">

    <!-- Success Header -->
    <div class="success-bar">
      <span class="success-icon">🎉</span>
      <div class="success-title">Order Confirmed!</div>
      <div class="success-sub">Your mood picked the perfect products</div>
    </div>

    <!-- Order Details -->
    <div class="order-details">
      <div class="detail-label">◈ Order Summary</div>

      <div class="detail-row">
        <div class="detail-key">Order ID</div>
        <div class="detail-val accent"><%= orderId %></div>
      </div>

      <div class="detail-row">
        <div class="detail-key">Customer</div>
        <div class="detail-val"><%= name %></div>
      </div>

      <div class="detail-row">
        <div class="detail-key">Mood at Purchase</div>
        <div class="detail-val"><%= moodEmoji %> <%= mood.substring(0,1).toUpperCase() + mood.substring(1) %></div>
      </div>

      <div class="detail-row">
        <div class="detail-key">Order Total</div>
        <div class="detail-val accent">₹<%= total %></div>
      </div>

      <div class="detail-row">
        <div class="detail-key">Order Date</div>
        <div class="detail-val"><%= timestamp %></div>
      </div>

      <div class="detail-row">
        <div class="detail-key">Status</div>
        <div class="detail-val" style="color:#22c55e">● Confirmed</div>
      </div>
    </div>

    <!-- Mood Message -->
    <div class="mood-message">
      <span class="mood-msg-emoji"><%= moodEmoji %></span>
      <div class="mood-msg-text"><%= moodMsg %></div>
    </div>

    <!-- Stats -->
    <div class="stats-row">
      <div class="stat-box">
        <div class="stat-num">₹<%= total %></div>
        <div class="stat-label">Total Spent</div>
      </div>
      <div class="stat-box">
        <div class="stat-num"><%= greenPts %></div>
        <div class="stat-label">Green Points</div>
      </div>
      <div class="stat-box">
        <div class="stat-num">2-3</div>
        <div class="stat-label">Days Delivery</div>
      </div>
    </div>

    <!-- Actions -->
    <div class="actions">
      <a href="moodcommerce.html" class="btn-primary">Continue Shopping</a>
      <a href="products.jsp?mood=<%= mood %>" class="btn-ghost">View More <%= moodEmoji %></a>
    </div>

  </div>

  <div class="footer-note">
    Module 4 — JSP Dynamic Pages ✓ · MoodCommerce · Order saved to XML via OrderServlet
  </div>

</body>
</html>
