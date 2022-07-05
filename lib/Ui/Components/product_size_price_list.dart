import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/product_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Dialogs/dialogs.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class SizePriceListView extends StatefulWidget {
  final List<String> sizes;
  final List<double> prices;
  final VoidCallback onChange;

  const SizePriceListView(
      {Key? key,
      required this.sizes,
      required this.prices,
      required this.onChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SizePriceListViewState();

  void updateForm(int index, String size, String price) {
    sizes[index] = size;
    prices[index] = double.parse(price);
  }
}

class _SizePriceListViewState extends State<SizePriceListView> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ProductManagerHelper productManagerHelper =
        Provider.of<HelpersProvider>(context, listen: false)
            .productManagerHelper;

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
                  showDialog(
                      context: context,
                      builder: (context) {
                        return SizePriceAlertDialog(
                          onConfirm: (String size, String price) {
                            widget.onChange();

                            productManagerHelper.addModel(size, price);
                          },
                          formKey: GlobalKey<FormState>(),
                        );
                      });
                },
              )
            ],
          )),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder<int>(
                valueListenable: productManagerHelper.modelsCount,
                builder: (context, value, child) {
                  return ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: widget.prices.length,
                    itemBuilder: (context, index) {
                      return _SizePriceForm(
                        index: index,
                        size: widget.sizes[index],
                        price: widget.prices[index],
                        removeForm: () {
                          widget.onChange();

                          productManagerHelper.removeModel(index);
                        },
                        updateForm: (index, size, price) {
                          widget.onChange();
                          productManagerHelper.updateModel(index, size, price);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}

typedef SizePriceCallback = void Function(int index, String size, String price);

class _SizePriceForm extends StatefulWidget {
  final String size;
  final double price;
  final int index;
  final VoidCallback removeForm;
  final SizePriceCallback updateForm;

  const _SizePriceForm(
      {Key? key,
      this.size = "",
      this.price = 0,
      required this.index,
      required this.removeForm,
      required this.updateForm})
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
    ProductManagerHelper productManagerHelper =
        Provider.of<HelpersProvider>(context, listen: false)
            .productManagerHelper;

    return InkResponse(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return SizePriceAlertDialog(
                initialPriceValue: price.toString(),
                initialSizeValue: size,
                onConfirm: (String size, String price) {
                  widget.updateForm(widget.index, size, price);
                },
                formKey: GlobalKey<FormState>(),
              );
            });
      },
      child: Card(
        child: ValueListenableBuilder<int>(
            valueListenable: productManagerHelper.formCounter,
            builder: (context, value, child) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: Text(
                    productManagerHelper.getSize(widget.index),
                    style: theme.textTheme.bodyText1,
                  )),
                  Expanded(
                      child: Text(
                    '${productManagerHelper.getPrice(widget.index)} $labelCurrency',
                    style: theme.textTheme.bodyText1,
                  )),
                  Flexible(
                      child: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      productManagerHelper.removeModel(widget.index);
                    },
                  )),
                ],
              );
            }),
      ),
    );
  }
}
