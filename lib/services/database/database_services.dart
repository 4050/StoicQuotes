import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stoic_quotes_app/models/models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();

  factory DatabaseService() => _instance;

  final CollectionReference firebaseQuotesCollection =
      FirebaseFirestore.instance.collection('quotes');

  // Insert a quote into Firestore
  Future<void> insertQuote(Quote quote) async {
    try {
      await firebaseQuotesCollection.add({
        'text': quote.text,
        'author': quote.author,
      });
    } catch (e) {
      print('Error inserting quote: $e');
    }
  }

  // Delete a quote from Firestore
  Future<void> deleteQuote(Quote quote) async {
    try {
      QuerySnapshot snapshot = await firebaseQuotesCollection
          .where('text', isEqualTo: quote.text)
          .where('author', isEqualTo: quote.author)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      print('Error deleting quote: $e');
    }
  }

  // Get all favorite quotes from Firestore
  Future<List<Quote>> getFavoriteQuotes() async {
    try {
      QuerySnapshot snapshot = await firebaseQuotesCollection.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Quote(
          text: data['text'],
          author: data['author'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching favorite quotes: $e');
      return [];
    }
  }
}
