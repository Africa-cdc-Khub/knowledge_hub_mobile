class OptionItemModel {
  final String id;
  final String name;

  OptionItemModel(this.id, this.name);


  OptionItemModel.init(this.id, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OptionItemModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}