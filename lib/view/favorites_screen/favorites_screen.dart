import 'package:flutter/cupertino.dart';
import 'package:stoic_quotes_app/services/services.dart';
import 'package:flutter/foundation.dart';
import 'package:stoic_quotes_app/models/models.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<Quote> favoriteQuotes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadFavorites(); // Обновляем данные при каждом открытии страницы
  }

  Future<void> loadFavorites() async {
    setState(() {
      isLoading = true;
    });

    final quotes = await _databaseService.getFavoriteQuotes();
    setState(() {
      favoriteQuotes = quotes;
      isLoading = false;
    });
  }

  Future<void> confirmDelete(Quote quote) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Удалить цитату?"),
        content: const Text("Вы уверены, что хотите удалить эту цитату?"),
        actions: [
          CupertinoDialogAction(
            child: const Text("Отмена"),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Удалить"),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await deleteFavorite(quote);
    }
  }

  Future<void> deleteFavorite(Quote quote) async {
    await _databaseService.deleteQuote(quote);
    await loadFavorites(); // Обновляем список после удаления
  }

   @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Избранное"),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.refresh, size: 28),
          onPressed: loadFavorites, // Кнопка обновления
        ),
      ),
      child: SafeArea(
        child: isLoading
            ? Center(
                child: CupertinoActivityIndicator(
                  radius: 16,
                ),
              )
            : favoriteQuotes.isEmpty
                ? Center(
                    child: Text(
                      "Список избранных цитат пуст",
                      style: TextStyle(fontSize: 18, color: CupertinoColors.systemGrey),
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: favoriteQuotes.length,
                    itemBuilder: (context, index) {
                      final quote = favoriteQuotes[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    quote.text,
                                    style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "- ${quote.author}",
                                    style: TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                                  ),
                                ],
                              ),
                            ),
                            if (!kIsWeb) // Удаление поддерживается только вне браузера
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                child: Icon(CupertinoIcons.delete, color: CupertinoColors.destructiveRed, size: 28),
                                onPressed: () async {
                                  await confirmDelete(quote);
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}