package com.bookstoreapi.bookstoreAppApi.entity;

import lombok.*;

import javax.persistence.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "book")
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title")
    private String title;

    @Column(name = "author")
    private String author;

    @Column(name = "description")
    private String description;

    @Column(name = "category")
    private String category;

    @Column(name = "img")
    private String img;

    @Column(name = "price")
    private float price;

    public boolean isInStock() {
        return inStock;
    }

    public void setInStock(boolean inStock) {
        this.inStock = inStock;
    }

    @Column(name = "in_stock", nullable = true)
    private Boolean inStock;

//    private float cost;

    public Book(Long id){
        this.id = id;
    }

//    @Transient
//    public float getDiscountPrice(){
//        if(discountPercent > 0){
//            return price * ((100 - discountPercent)/100);
//        }
//        return this.price;
//    }
}
