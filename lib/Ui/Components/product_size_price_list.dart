import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/optional_item.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Ui/Components/product_components.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

class SizePriceListView extends StatefulWidget {
  final List<String> size;
  final List<double> price;

  void removeElement(int index) {
    size.removeAt(index);
    price.removeAt(index);
  }

  void addElement() {
    size.add("");
    price.add(0);
  }

  const SizePriceListView({Key? key, required this.size, required this.price})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SizePriceListViewState();
}

class _SizePriceListViewState extends State<SizePriceListView> {
  @override
  Widget build(BuildContext context) {
    int itemsCount = widget.price.length;
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Flexible(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                addSizeLabel,
                style: theme.textTheme.headline4,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  setState(() {
                    widget.addElement();
                  });
                },
              )
            ],
          )),
          const Divider(),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: itemsCount,
              itemBuilder: (context, index) {
                return _SizePriceForm(
                  index: index,
                  size: widget.size[index],
                  price: widget.price[index],
                  removeForm: () {},
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SizePriceForm extends StatefulWidget {
  final String size;
  final double price;
  final int index;
  final VoidCallback removeForm;

  const _SizePriceForm(
      {Key? key,
      this.size = "",
      this.price = 0,
      required this.index,
      required this.removeForm})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SizePriceFormState();
}

class _SizePriceFormState extends State<_SizePriceForm> {
  String size = "";
  double price = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    size = widget.size;
    price = widget.price;

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
            child: InkResponse(
          child: Text(
            size,
            style: theme.textTheme.bodyText1,
          ),
          onTap: () {},
        )),
        Expanded(
            child: InkResponse(
          child: Text(
            '${price.toString()} $labelCurrency',
            style: theme.textTheme.bodyText1,
          ),
          onTap: () {},
        )),
        Flexible(
            child: IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {},
        )),
      ],
    );
  }
}
