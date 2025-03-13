package model;

import java.io.Serializable;

/**
 * Lớp đại diện cho một mục trong giỏ hàng
 */
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;
    private Product product;
    private Variant variant;
    private int quantity;

    public CartItem(Product product, Variant variant, int quantity) {
        this.product = product;
        this.variant = variant;
        this.quantity = quantity;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public Variant getVariant() {
        return variant;
    }

    public void setVariant(Variant variant) {
        this.variant = variant;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public double getTotal() {
        return variant.getPrice() * quantity;
    }
} 