class OptionalItem {
  final String _label;
  final String? _icon;

  OptionalItem(this._label, [this._icon]);

  String getLabel() {
    return _label;
  }

  String getImageUrl() {
    return _icon ?? "";
  }
}
