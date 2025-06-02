/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */


    import java.io.Serializable ;

    public class ProductStats implements Serializable {

        private static final long serialVersionUID = 1L;
        private int id;
        private String name;
        private String image;
        private String tittle;
        private String description;
        private int totalQuantitySold;    
        private double totalRevenue;      
        private int totalRemainingStock;  

        public ProductStats(int id, String name, String image, String tittle, String description,
                int totalQuantitySold, double totalRevenue, int totalRemainingStock) {
            this.id = id;
            this.name = name;
            this.image = image;
            this.tittle = tittle;
            this.description = description;
            this.totalQuantitySold = totalQuantitySold;
            this.totalRevenue = totalRevenue;
            this.totalRemainingStock = totalRemainingStock;
        }

    public ProductStats() {
    }

        // Getters và Setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getImage() {
            return image;
        }

        public void setImage(String image) {
            this.image = image;
        }

        public String getTittle() {
            return tittle;
        }

        public void setTittle(String tittle) {
            this.tittle = tittle;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public int getTotalQuantitySold() {
            return totalQuantitySold;
        }

        public void setTotalQuantitySold(int totalQuantitySold) {
            this.totalQuantitySold = totalQuantitySold;
        }

        public double getTotalRevenue() {
            return totalRevenue;
        }

        public void setTotalRevenue(double totalRevenue) {
            this.totalRevenue = totalRevenue;
        }

        public int getTotalRemainingStock() {
            return totalRemainingStock;
        }

        public void setTotalRemainingStock(int totalRemainingStock) {
            this.totalRemainingStock = totalRemainingStock;
        }
    }

