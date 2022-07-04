import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';

class SizePriceListView extends StatefulWidget {
  final List<String> size;
  final List<double> price;

  void removeElement(int index) {
    size.removeAt(index);
    price.removeAt(index);
  }

  void addElement() {
    size.add("Default");
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
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
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
              itemCount: widget.price.length,
              itemBuilder: (context, index) {
                return _SizePriceForm(
                  index: index,
                  size: widget.size[index],
                  price: widget.price[index],
                  removeForm: () {
                    setState(() {
                      widget.removeElement(index);
                    });
                  },
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
  late String size;
  late double price;

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
          onPressed: widget.removeForm,
        )),
      ],
    );
  }
}