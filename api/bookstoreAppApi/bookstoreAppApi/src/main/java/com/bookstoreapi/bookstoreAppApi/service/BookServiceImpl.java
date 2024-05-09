package com.bookstoreapi.bookstoreAppApi.service;


import com.bookstoreapi.bookstoreAppApi.entity.Book;
import com.bookstoreapi.bookstoreAppApi.repository.BookRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

@Service
@Primary
public class BookServiceImpl implements BookService {
    @Autowired
    private BookRepository bookRepository;

    @Override
    public Book addBook(Book book) {
        return bookRepository.save(book);
    }

    @Override
    public Book editBook(Book book) {
        boolean exist = bookRepository.existsById(book.getId());
        if (exist) {
            return bookRepository.save(book);
        }
        return null;
    }

    @Override
    public void deleteBook(Long id) {
        bookRepository.deleteById(id);
    }

    @Override
    public Page<Book> getRequestFilters(int page, int limit, String bookTitle, Sort.Direction sortType) {
        Page<Book> bookPage = null;
        if (bookTitle == null && sortType == null) {
            bookPage = getBooksList(page, limit);
        }
        if (bookTitle != null && sortType == null) {
            bookPage = findBooksByTitle(page, limit, bookTitle);
        }
        if (bookTitle == null && sortType != null) {
            bookPage = getBooksOrderByPrice(page, limit, sortType);
        }
        if (bookTitle != null && sortType != null) {
            bookPage = findBooksByTitleAndOrderByPrice(page, limit, bookTitle, sortType);
        }
        return bookPage;
    }

    private Page<Book> getBooksList(int page, int limit) {
        Pageable pageable = PageRequest.of(page, limit);
        return bookRepository.findAll(pageable);
    }

    private Page<Book> findBooksByTitle(int page, int limit, String bookTitle) {
        Pageable pageable = PageRequest.of(page, limit);
        return bookRepository.findByTitleContaining(bookTitle, pageable);
    }


    private Page<Book> getBooksOrderByPrice(int page, int limit, Sort.Direction sortType) {
        Sort sort = Sort.by(sortType, "price");
        Pageable pageable = PageRequest.of(page, limit, sort);
        return bookRepository.findAll(pageable);
    }

    private Page<Book> findBooksByTitleAndOrderByPrice(int page, int limit,
                                                       String bookTitle,
                                                       Sort.Direction sortType) {
        Sort sort = Sort.by(sortType, "price");
        Pageable pageable = PageRequest.of(page, limit, sort);
        return bookRepository.findByTitleContaining(bookTitle, pageable);
    }
}
