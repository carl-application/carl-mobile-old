class CardDetailBackArguments {
  final int cardId;
  final bool isBlacklisted;

  CardDetailBackArguments(this.cardId, this.isBlacklisted);

  @override
  String toString() => 'CardDetailBackArguments { cardId: $cardId, isBlacklisted: $isBlacklisted }';
}
