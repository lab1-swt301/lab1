/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.io.Serializable;

/**
 *
 * @author LENOVO
 */
public class Variant implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id, productId, stock;
    private double price;
    private Color color;
    private Size size;
    private Product product;
    

    public Variant(int id, int productId, Color color, Size size, double price, int stock) {
        this.id = id;
        this.productId = productId;
        this.color = color;
        this.size = size;
        this.stock = stock;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public int getProductId() {
        return productId;
    }

    public Color getColor() {
        return color;
    }

    public Size getSize() {
        return size;
    }

    public int getStock() {
        return stock;
    }

    public double getPrice() {
        return price;
    }
}
