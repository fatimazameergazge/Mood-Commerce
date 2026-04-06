<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="javax.xml.parsers.*" %>
<%--
    MoodCommerce — products.jsp
    Dynamically renders products from XML based on mood
    URL: /MoodCommerce/products.jsp?mood=happy
--%>
<%
    // Get mood from URL parameter
    String mood = request.getParameter("mood");
    if (mood == null || mood.isEmpty()) {
        mood = "happy"; // default mood
    }

    // Mood titles map
    String moodTitle = "Top Picks";
    String moodEmoji = "✨";
    switch(mood) {
        case "happy":    moodTitle = "Happy Picks For You";      moodEmoji = "😄"; break;
        case "calm":     moodTitle = "Calm & Collected Finds";   moodEmoji = "😌"; break;
        case "stressed": moodTitle = "Stress-Relief Essentials"; moodEmoji = "💆"; break;
        case "romantic": moodTitle = "Romance Collection";       moodEmoji = "🥰"; break;
        case "excited":  moodTitle = "High Energy Picks";        moodEmoji = "🤩"; break;
        case "sad":      moodTitle = "Comfort & Care Picks";     moodEmoji = "🧸"; break;
    }

    // Parse products.xml
    String xmlPath = application.getRealPath("/WEB-INF/xml/products.xml");
    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
    DocumentBuilder builder = factory.newDocumentBuilder();
    Document doc = builder.parse(new File(xmlPath));
    doc.getDocumentElement().normalize();
    NodeList products = doc.getElementsByTagName("product");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>MoodCommerce — <%= moodEmoji %> <%= moodTitle %></title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;700;800&family=DM+Mono:wght@300;500&display=swap" rel="stylesheet"/>
  <style>
    :root { --bg:#060810; --card:#111827; --border:#1f2937; --accent:#00f5c4; --text:#f0f4ff; --muted:#6b7280; }
    *,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
    body { background:var(--bg); color:var(--text); font-family:'DM Mono',monospace; min-height:100vh; }
    body::after { content:''; position:fixed; inset:0; background-image:linear-gradient(rgba(0,245,196,0.03) 1px,transparent 1px),linear-gradient(90deg,rgba(0,245,196,0.03) 1px,transparent 1px); background-size:48px 48px; pointer-events:none; z-index:0; }

    /* NAV */
    nav { position:sticky; top:0; z-index:100; display:flex; align-items:center; justify-content:space-between; padding:1.2rem 3rem; background:rgba(6,8,16,0.9); backdrop-filter:blur(20px); border-bottom:1px solid var(--border); }
    .nav-logo { font-family:'Syne',sans-serif; font-size:1.4rem; font-weight:800; color:var(--accent); text-decoration:none; }
    .nav-links { display:flex; gap:1rem; }
    .nav-link { font-size:0.68rem; letter-spacing:0.12em; text-transform:uppercase; color:var(--muted); text-decoration:none; padding:0.4rem 0.8rem; border:1px solid transparent; transition:all 0.2s; }
    .nav-link:hover,.nav-link.active { color:var(--accent); border-color:var(--accent); }

    /* MOOD FILTER */
    .mood-filter { padding:2rem 3rem 1rem; position:relative; z-index:1; }
    .filter-label { font-size:0.62rem; letter-spacing:0.2em; text-transform:uppercase; color:var(--accent); margin-bottom:1rem; }
    .mood-btns { display:flex; gap:0.8rem; flex-wrap:wrap; }
    .mood-btn { background:none; border:1px solid var(--border); color:var(--muted); font-family:'DM Mono',monospace; font-size:0.68rem; letter-spacing:0.1em; padding:0.5rem 1.2rem; cursor:pointer; text-decoration:none; transition:all 0.2s; display:inline-block; }
    .mood-btn:hover,.mood-btn.active { border-color:var(--accent); color:var(--accent); background:rgba(0,245,196,0.05); }

    /* PAGE HEADER */
    .page-header { padding:2rem 3rem; position:relative; z-index:1; border-bottom:1px solid var(--border); }
    .page-tag { font-size:0.62rem; letter-spacing:0.2em; text-transform:uppercase; color:var(--accent); margin-bottom:0.8rem; }
    .page-title { font-family:'Syne',sans-serif; font-size:2.5rem; font-weight:800; letter-spacing:-0.02em; }
    .product-count { font-size:0.68rem; color:var(--muted); margin-top:0.5rem; }

    /* PRODUCTS GRID */
    .products-section { padding:2rem 3rem 6rem; position:relative; z-index:1; }
    .products-grid { display:grid; grid-template-columns:repeat(4,1fr); gap:1.5px; }

    .product-card { background:var(--card); position:relative; overflow:hidden; transition:transform 0.3s; animation:fadeUp 0.4s ease both; }
    @keyframes fadeUp { from{opacity:0;transform:translateY(16px)} to{opacity:1;transform:translateY(0)} }
    .product-card:hover { transform:scale(0.985); z-index:2; }

    .product-img { aspect-ratio:1; background:#0d1117; display:flex; align-items:center; justify-content:center; font-size:4rem; position:relative; }
    .product-img::after { content:''; position:absolute; inset:0; background:linear-gradient(to bottom,transparent 50%,rgba(0,0,0,0.6)); }

    .eco-badge { position:absolute; top:12px; left:12px; background:rgba(0,245,196,0.12); border:1px solid var(--accent); color:var(--accent); font-size:0.55rem; letter-spacing:0.1em; padding:0.2rem 0.5rem; text-transform:uppercase; z-index:2; }
    .stock-badge { position:absolute; top:12px; right:12px; background:rgba(0,0,0,0.75); border:1px solid var(--border); color:var(--muted); font-size:0.55rem; padding:0.2rem 0.5rem; z-index:2; }
    .stock-badge.low { border-color:#ef4444; color:#ef4444; }

    .product-info { padding:1.2rem; border-top:1px solid var(--border); }
    .product-cat { font-size:0.58rem; letter-spacing:0.15em; text-transform:uppercase; color:var(--muted); margin-bottom:0.3rem; }
    .product-name { font-family:'Syne',sans-serif; font-size:0.95rem; font-weight:700; margin-bottom:0.5rem; line-height:1.2; }
    .product-desc { font-size:0.6rem; color:var(--muted); line-height:1.6; margin-bottom:0.8rem; }
    .product-footer { display:flex; align-items:center; justify-content:space-between; }
    .product-price { font-size:0.9rem; color:var(--accent); }
    .carbon-info { font-size:0.55rem; color:var(--muted); }
    .add-btn { background:none; border:1px solid var(--border); color:var(--muted); font-family:'DM Mono',monospace; font-size:0.62rem; padding:0.4rem 0.8rem; cursor:pointer; transition:all 0.2s; }
    .add-btn:hover { background:var(--accent); color:#000; border-color:var(--accent); }

    /* NO PRODUCTS */
    .no-products { text-align:center; padding:5rem 2rem; color:var(--muted); }
    .no-products-emoji { font-size:4rem; margin-bottom:1rem; display:block; }
    .no-products-text { font-size:0.8rem; }

    /* FOOTER */
    footer { padding:2rem 3rem; border-top:1px solid var(--border); display:flex; justify-content:space-between; align-items:center; position:relative; z-index:1; }
    .footer-text { font-size:0.6rem; color:var(--muted); }
    .footer-logo { font-family:'Syne',sans-serif; font-size:1rem; font-weight:800; color:var(--accent); }

    @media(max-width:900px) { .products-grid{grid-template-columns:repeat(2,1fr);} nav{padding:1rem 1.5rem;} .nav-links{display:none;} }
  </style>
</head>
<body>

  <!-- NAV -->
  <nav>
    <a href="moodcommerce.html" class="nav-logo">MoodCommerce</a>
    <div class="nav-links">
      <a href="moodcommerce.html" class="nav-link">← Back to Shop</a>
      <a href="products.jsp?mood=happy" class="nav-link <%= mood.equals("happy") ? "active" : "" %>">😄 Happy</a>
      <a href="products.jsp?mood=calm" class="nav-link <%= mood.equals("calm") ? "active" : "" %>">😌 Calm</a>
      <a href="products.jsp?mood=stressed" class="nav-link <%= mood.equals("stressed") ? "active" : "" %>">😤 Stressed</a>
      <a href="products.jsp?mood=romantic" class="nav-link <%= mood.equals("romantic") ? "active" : "" %>">🥰 Romantic</a>
      <a href="products.jsp?mood=excited" class="nav-link <%= mood.equals("excited") ? "active" : "" %>">🤩 Excited</a>
      <a href="products.jsp?mood=sad" class="nav-link <%= mood.equals("sad") ? "active" : "" %>">😔 Sad</a>
    </div>
  </nav>

  <!-- MOOD FILTER -->
  <div class="mood-filter">
    <div class="filter-label">◈ Filter by Mood</div>
    <div class="mood-btns">
      <a href="products.jsp?mood=happy"    class="mood-btn <%= mood.equals("happy")    ? "active" : "" %>">😄 Happy</a>
      <a href="products.jsp?mood=calm"     class="mood-btn <%= mood.equals("calm")     ? "active" : "" %>">😌 Calm</a>
      <a href="products.jsp?mood=stressed" class="mood-btn <%= mood.equals("stressed") ? "active" : "" %>">😤 Stressed</a>
      <a href="products.jsp?mood=romantic" class="mood-btn <%= mood.equals("romantic") ? "active" : "" %>">🥰 Romantic</a>
      <a href="products.jsp?mood=excited"  class="mood-btn <%= mood.equals("excited")  ? "active" : "" %>">🤩 Excited</a>
      <a href="products.jsp?mood=sad"      class="mood-btn <%= mood.equals("sad")      ? "active" : "" %>">😔 Sad</a>
    </div>
  </div>

  <!-- PAGE HEADER -->
  <div class="page-header">
    <div class="page-tag">◈ JSP Dynamic Page — Mood: <%= mood.toUpperCase() %></div>
    <h1 class="page-title"><%= moodEmoji %> <%= moodTitle %></h1>
    <div class="product-count">
      <%
        int count = 0;
        for(int i = 0; i < products.getLength(); i++) {
          Element p = (Element) products.item(i);
          if(p.getAttribute("mood").equalsIgnoreCase(mood)) count++;
        }
      %>
      <%= count %> products found for <%= mood %> mood
    </div>
  </div>

  <!-- PRODUCTS -->
  <section class="products-section">
    <div class="products-grid">
      <%
        boolean hasProducts = false;
        for(int i = 0; i < products.getLength(); i++) {
          Element p = (Element) products.item(i);
          if(!p.getAttribute("mood").equalsIgnoreCase(mood)) continue;
          hasProducts = true;

          String name     = getTagValue("name", p);
          String category = getTagValue("category", p);
          String price    = getTagValue("price", p);
          String eco      = getTagValue("eco", p);
          String carbon   = getTagValue("carbon", p);
          String stock    = getTagValue("stock", p);
          String emoji    = getTagValue("emoji", p);
          String desc     = getTagValue("description", p);
          String id       = p.getAttribute("id");

          int stockNum = Integer.parseInt(stock);
          String stockClass = stockNum < 20 ? "low" : "";
          String stockLabel = stockNum < 20 ? "⚠ Low Stock: " + stock : "Stock: " + stock;
      %>
      <div class="product-card" style="animation-delay:<%= i * 0.08 %>s">
        <div class="product-img">
          <%= emoji %>
          <div class="eco-badge">Eco <%= eco %></div>
          <div class="stock-badge <%= stockClass %>"><%= stockLabel %></div>
        </div>
        <div class="product-info">
          <div class="product-cat"><%= category %></div>
          <div class="product-name"><%= name %></div>
          <div class="product-desc"><%= desc %></div>
          <div class="product-footer">
            <div>
              <div class="product-price">₹<%= Integer.parseInt(price) %></div>
              <div class="carbon-info"><%= carbon %> kg CO₂</div>
            </div>
            <button class="add-btn" onclick="addToCart('<%= id %>','<%= name %>','<%= price %>')">+ Add</button>
          </div>
        </div>
      </div>
      <% } %>

      <% if(!hasProducts) { %>
      <div class="no-products" style="grid-column:1/-1">
        <span class="no-products-emoji">😕</span>
        <div class="no-products-text">No products found for "<%= mood %>" mood</div>
      </div>
      <% } %>
    </div>
  </section>

  <footer>
    <div class="footer-logo">MoodCommerce</div>
    <div class="footer-text">Module 4 — JSP Dynamic Pages ✓ · Powered by Apache Tomcat</div>
  </footer>

  <script>
    function addToCart(id, name, price) {
      alert('✅ ' + name + ' added to cart!\nPrice: ₹' + price);
    }
  </script>

<%!
  // Helper method to get XML tag value
  private String getTagValue(String tag, Element element) {
    NodeList nodeList = element.getElementsByTagName(tag);
    if(nodeList.getLength() == 0) return "";
    return nodeList.item(0).getTextContent().trim();
  }
%>

</body>
</html>
