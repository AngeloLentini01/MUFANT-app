import 'package:app/data/cart/cart_item_model.dart';
import 'package:app/data/generic/money/money_extensions.dart';
import 'package:money2/money2.dart'; // Assuming you're using a Money package
import 'book_genre_model.dart';

/// Represents a book item that can be added to a shopping cart.
/// Extends CartItemModel to inherit properties for cart items.
///
/// @property author The author of the book
/// @property publisher The publisher of the book
/// @property bookGenre The genre categorization of the book
/// @property isAvailable Calculated property that returns true if the book is in stock
/// @property isOnSale Calculated property that returns true if the book has a non-zero price
class BookModel extends CartItemModel {
  final String author;
  final String publisher;
  final BookGenreModel bookGenre;

  BookModel({
    required super.id,
    required super.details,
    Money? price,
    required super.quantity,
    required this.author,
    required this.publisher,
    required this.bookGenre,
  }) : super(
         price: price ?? zeroMoney,
       );

  bool get isAvailable => quantity > 0;
  bool get isOnSale => price > zeroMoney;
}
