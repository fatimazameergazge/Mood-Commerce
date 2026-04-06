package com.moodcommerce.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import org.w3c.dom.*;
import javax.xml.parsers.*;
import java.io.*;

@WebServlet("/ProductServlet")
public class ProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");

        String mood = request.getParameter("mood");
        if (mood == null || mood.isEmpty()) {
            mood = "default";
        }

        PrintWriter out = response.getWriter();

        try {
            String xmlPath = getServletContext().getRealPath("/WEB-INF/xml/products.xml");
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new File(xmlPath));
            doc.getDocumentElement().normalize();

            NodeList productList = doc.getElementsByTagName("product");
            StringBuilder json = new StringBuilder();
            json.append("[");

            boolean first = true;
            for (int i = 0; i < productList.getLength(); i++) {
                Element product = (Element) productList.item(i);
                String productMood = product.getAttribute("mood");

                if (!productMood.equalsIgnoreCase(mood)) continue;

                if (!first) json.append(",");
                first = false;

                json.append("{");
                json.append("\"id\":\"").append(product.getAttribute("id")).append("\",");
                json.append("\"mood\":\"").append(productMood).append("\",");
                json.append("\"name\":\"").append(getTagValue("name", product)).append("\",");
                json.append("\"category\":\"").append(getTagValue("category", product)).append("\",");
                json.append("\"price\":").append(getTagValue("price", product)).append(",");
                json.append("\"eco\":\"").append(getTagValue("eco", product)).append("\",");
                json.append("\"carbon\":").append(getTagValue("carbon", product)).append(",");
                json.append("\"stock\":").append(getTagValue("stock", product)).append(",");
                json.append("\"emoji\":\"").append(getTagValue("emoji", product)).append("\",");
                json.append("\"description\":\"").append(getTagValue("description", product)).append("\"");
                json.append("}");
            }

            json.append("]");
            out.print(json.toString());
            out.flush();

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private String getTagValue(String tag, Element element) {
        NodeList nodeList = element.getElementsByTagName(tag);
        if (nodeList.getLength() == 0) return "";
        return nodeList.item(0).getTextContent().trim()
               .replace("\"", "'")
               .replace("&amp;", "&");
    }
}