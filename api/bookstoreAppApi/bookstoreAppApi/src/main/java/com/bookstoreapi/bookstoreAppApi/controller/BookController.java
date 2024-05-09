package com.bookstoreapi.bookstoreAppApi.controller;



import com.bookstoreapi.bookstoreAppApi.entity.Book;
import com.bookstoreapi.bookstoreAppApi.handlers.ResponseHandler;
import com.bookstoreapi.bookstoreAppApi.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.websocket.server.PathParam;
import java.util.List;
import java.util.Objects;

@RestController
@CrossOrigin("*")
@RequestMapping("/api/books")
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping
    public ResponseEntity<Object> getBooks(@RequestParam(required = false,defaultValue = "0") int page,
                                              @RequestParam(required = false,defaultValue = "5") int limit,
                                              @RequestParam(required = false)  String bookName,
                                              @RequestParam(required = false) Sort.Direction sortType){
        try {
            Page<Book> bookPage = bookService.getRequestFilters(page,limit,bookName,sortType);
            return ResponseHandler.handleResponse("Successfully get books",HttpStatus.OK,bookPage);
        }catch (Exception e){
            return ResponseHandler.handleResponse("ERROR",HttpStatus.BAD_REQUEST,e.getMessage());
        }
    }

    @PostMapping("/add")
    public ResponseEntity<Object> addBook(@RequestBody @Valid Book book){
        try {
            Book addedBook = bookService.addBook(book);
            return ResponseHandler.handleResponse("Successfully add book", HttpStatus.OK,addedBook);
        }catch (Exception e){
            return ResponseHandler.handleResponse("ERROR", HttpStatus.BAD_REQUEST,e.getMessage());
        }
    }

    @PutMapping("/edit")
    public ResponseEntity<Object> editBook(@RequestBody @Valid Book book){
        try {
            Book editedBook = bookService.editBook(book);
            if(editedBook!=null){
                return ResponseHandler.handleResponse("Successfully edit book", HttpStatus.OK,editedBook);
            }else{
                return ResponseHandler.handleResponse("Book Id Not exist", HttpStatus.BAD_REQUEST,null);
            }
        }catch (Exception e){
            return ResponseHandler.handleResponse("ERROR", HttpStatus.BAD_REQUEST,e.getMessage());
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<Object> deleteBook(@PathVariable Long id){
        try {
            bookService.deleteBook(id);
            return ResponseHandler.handleResponse("Successfully delete book", HttpStatus.OK,null);
        }catch (Exception e){
            return ResponseHandler.handleResponse("ERROR", HttpStatus.BAD_REQUEST,e.getMessage());
        }
    }

}
