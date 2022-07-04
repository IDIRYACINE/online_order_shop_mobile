class OrderStatus {
  static const String noOrder = "noOrder";
  static const String waiting = "waiting";
  static const String confirmed = "confirmed";
  static const String onDelivery = "onDelivery";
  static const String delivered = "delivered";
  static final List<String> _val = [waiting, confirmed, onDelivery];
  static final List<String> values = ["attendu", "confirmer", "livraison"];

  static const Map<String, int> _states = {
    waiting: 0,
    confirmed: 1,
    onDelivery: 2,
    delivered: 3,
    noOrder: -1
  };

  static int getStateRank(String state) => _states[state]!;
  static String frToEnStatus(String state) {
    for (int i = 0; i < 3; i++) {
      if (values[i] == state) {
        return _val[i];
      }
    }
    return _val[0];
  }
}
