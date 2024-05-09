package com.bookstoreapi.bookstoreAppApi.service;

import com.bookstoreapi.bookstoreAppApi.entity.Book;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;

public interface BookService {
    Book addBook(Book book);

    Book editBook(Book book);

    void deleteBook(Long id);

    Page<Book> getRequestFilters(int page, int limit, String bookTitle, Sort.Direction sortType);
}
