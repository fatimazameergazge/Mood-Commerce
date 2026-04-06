// ============================================================
//  MoodCommerce — OrderServlet.java
//  Receives order from frontend, saves it to products.xml
//  URL: POST /MoodCommerce/OrderServlet
// ============================================================

package com.moodcommerce.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;

import org.w3c.dom.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import java.io.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {

    // ─── POST REQUEST ─────────────────────────────────────────
    // Called when user places an order from the cart
    // Receives: productId, productName, mood, price, qty, userMood
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        response.setHeader("Access-Control-Allow-Headers", "Content-Type");

        PrintWriter out = response.getWriter();

        // ── Read order details from request ──────────────────
        String productId   = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String mood        = request.getParameter("mood");
        String price       = request.getParameter("price");
        String qty         = request.getParameter("qty");
        String userName    = request.getParameter("userName");
        String address     = request.getParameter("address");

        // Basic validation
        if (productId == null || productName == null || price == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\",\"message\":\"Missing required fields\"}");
            return;
        }

        try {
            // ── Parse products.xml ───────────────────────────
            String xmlPath = getServletContext()
                .getRealPath("/WEB-INF/xml/products.xml");

            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder        = factory.newDocumentBuilder();
            Document doc                   = builder.parse(new File(xmlPath));
            doc.getDocumentElement().normalize();

            // ── Find <orders> node ───────────────────────────
            NodeList ordersList = doc.getElementsByTagName("orders");
            Element ordersNode  = (Element) ordersList.item(0);

            // ── Create new <order> element ───────────────────
            Element order = doc.createElement("order");

            // Generate unique order ID
            String orderId = "ORD-" + System.currentTimeMillis();
            order.setAttribute("id", orderId);
            order.setAttribute("status", "placed");

            // Timestamp
            String timestamp = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

            // Add child elements
            appendElement(doc, order, "orderId",     orderId);
            appendElement(doc, order, "productId",   productId);
            appendElement(doc, order, "productName", productName);
            appendElement(doc, order, "mood",        mood);
            appendElement(doc, order, "price",       price);
            appendElement(doc, order, "qty",         qty != null ? qty : "1");
            appendElement(doc, order, "userName",    userName != null ? userName : "Guest");
            appendElement(doc, order, "address",     address != null ? address : "Not provided");
            appendElement(doc, order, "timestamp",   timestamp);

            // ── Append order to <orders> node ────────────────
            ordersNode.appendChild(order);

            // ── Write updated XML back to file ────────────────
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            Transformer transformer = transformerFactory.newTransformer();
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "2");

            DOMSource source       = new DOMSource(doc);
            StreamResult result    = new StreamResult(new File(xmlPath));
            transformer.transform(source, result);

            // ── Update stock in XML ───────────────────────────
            updateStock(doc, productId, xmlPath);

            // ── Send success response ─────────────────────────
            out.print("{");
            out.print("\"status\":\"success\",");
            out.print("\"orderId\":\"" + orderId + "\",");
            out.print("\"message\":\"Order placed successfully!\",");
            out.print("\"timestamp\":\"" + timestamp + "\"");
            out.print("}");
            out.flush();

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\",\"message\":\"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }

    // ─── HELPER: Append child element ────────────────────────
    private void appendElement(Document doc, Element parent, String tag, String value) {
        Element el = doc.createElement(tag);
        el.setTextContent(value);
        parent.appendChild(el);
    }

    // ─── HELPER: Reduce stock by 1 after order ────────────────
    private void updateStock(Document doc, String productId, String xmlPath) {
        try {
            NodeList products = doc.getElementsByTagName("product");
            for (int i = 0; i < products.getLength(); i++) {
                Element p = (Element) products.item(i);
                if (p.getAttribute("id").equals(productId)) {
                    NodeList stockList = p.getElementsByTagName("stock");
                    if (stockList.getLength() > 0) {
                        int currentStock = Integer.parseInt(
                            stockList.item(0).getTextContent().trim()
                        );
                        if (currentStock > 0) {
                            stockList.item(0).setTextContent(String.valueOf(currentStock - 1));
                        }
                    }
                    break;
                }
            }
            // Save updated stock
            TransformerFactory tf  = TransformerFactory.newInstance();
            Transformer t          = tf.newTransformer();
            t.setOutputProperty(OutputKeys.INDENT, "yes");
            t.transform(new DOMSource(doc), new StreamResult(new File(xmlPath)));

        } catch (Exception e) {
            System.err.println("Stock update failed: " + e.getMessage());
        }
    }

    // ─── Handle OPTIONS preflight ─────────────────────────────
    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
        res.setHeader("Access-Control-Allow-Headers", "Content-Type");
        res.setStatus(HttpServletResponse.SC_OK);
    }
}
