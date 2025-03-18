use starknet::contract;
use starknet::storage;
use starknet::interface;

#[starknet::contract]
mod bookstore {
    use super::*;

    #[storage]
    struct Storage {
        books: Map<felt252, Book>,
    }

    #[derive(Drop, starknet::Storage)]
    struct Book {
        title: felt252,
        author: felt252,
        description: felt252,
        price: u16,
        quantity: u8,
    }

    #[external]
    fn add_book(
        ref self: ContractState,
        title: felt252,
        author: felt252,
        description: felt252,
        price: u16,
        quantity: u8,
    ) {
        self.books.write(title, Book { title, author, description, price, quantity });
    }

    #[external]
    fn update_book(
        ref self: ContractState,
        title: felt252,
        new_price: u16,
        new_quantity: u8,
    ) {
        let mut book = self.books.read(title).unwrap();
        book.price = new_price;
        book.quantity = new_quantity;
        self.books.write(title, book);
    }

    #[external]
    fn remove_book(ref self: ContractState, title: felt252) {
        self.books.remove(title);
    }
}

#[starknet::contract]
mod purchase {
    use super::*;
    use bookstore::bookstore;

    #[external]
    fn buy_book(ref self: ContractState, bookstore_address: ContractAddress, title: felt252) {
        let mut book = bookstore::get_book(bookstore_address, title);
        assert!(book.quantity > 0, "Out of stock");
        book.quantity -= 1;
        bookstore::update_book(bookstore_address, title, book.price, book.quantity);
    }
}
