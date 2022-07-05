import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/catalogue_helper.dart';
import 'package:online_order_shop_mobile/Application/Catalogue/product_manager_helper.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Application/Providers/navigation_provider.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/category_model.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/optional_item.dart';
import 'package:online_order_shop_mobile/Domain/Catalogue/product_model.dart';
import 'package:online_order_shop_mobile/Infrastructure/Database/idatabase.dart';
import 'package:online_order_shop_mobile/Infrastructure/Server/ionline_data_service.dart';
import 'package:online_order_shop_mobile/Infrastructure/service_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/local_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/Images/network_image.dart';
import 'package:online_order_shop_mobile/Ui/Components/cards.dart';
import 'package:online_order_shop_mobile/Ui/Components/product_components.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final double dividerThickness = 2.0;
  final double appBarElevation = 0.0;
  final double padding = 15.0;
  final double backbuttonPadding = 10.0;
  final double optionalItemsYpadding = 4.0;
  final int productDescriptionMaxLines = 2;

  final int imageFlex = 1;
  final int productFlex = 1;

  final int productNameFlex = 1;
  final int productPriceFlex = 1;
  final int productDescriptionFlex = 1;

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ThemeData theme;

  bool initiliazed = false;

  late NavigationProvider navigationProvider;
  late CatalogueHelper catalogueHelper;
  late ProductManagerHelper productManagerHelper;

  void setup(BuildContext context) {
    if (!initiliazed) {
      theme = Theme.of(context);

      navigationProvider =
          Provider.of<NavigationProvider>(context, listen: false);

      catalogueHelper =
          Provider.of<HelpersProvider>(context, listen: false).catalogueHelper;

      productManagerHelper =
          Provider.of<HelpersProvider>(context, listen: false)
              .productManagerHelper;

      initiliazed = true;
    }
  }

  ValueNotifier<int> currentSizeIndex = ValueNotifier(0);

  VoidCallback? toggleLastSelectedSize;

  OptionalItem getSize(int index) {
    return OptionalItem(productManagerHelper.getSize(index));
  }

  void selectSize(int index, VoidCallback selfToggle) {
    if (toggleLastSelectedSize != null) {
      toggleLastSelectedSize!();
    }

    toggleLastSelectedSize = selfToggle;
    currentSizeIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    setup(context);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Card(
                elevation: 4.0,
                color: theme.cardColor,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: theme.colorScheme.secondaryVariant,
                    ))),
            Card(
              elevation: 4.0,
              color: theme.cardColor,
              child: IconButton(
                  onPressed: () {
                    productManagerHelper.applyChanges();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.done,
                    color: theme.colorScheme.secondaryVariant,
                  )),
            ),
          ]),
        ),
        body: Padding(
          padding: EdgeInsets.all(widget.padding),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: widget.imageFlex,
                  child: InkResponse(
                    onTap: () {
                      productManagerHelper.browseImage();
                    },
                    child: ValueListenableBuilder<String>(
                        valueListenable: productManagerHelper.image,
                        builder: (context, value, child) {
                          if (productManagerHelper.editMode) {
                            return CustomNetworkImage(
                              value,
                              backupImage: uploadImageUrl,
                              fit: BoxFit.fill,
                            );
                          }
                          return LocalImage(
                            value,
                            backupImage: uploadImageUrl,
                            fit: BoxFit.fill,
                          );
                        }),
                  )),
              Expanded(
                flex: widget.productFlex,
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                          child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Divider(
                            thickness: widget.dividerThickness,
                          ),
                        ],
                      )),
                      InformationCard(
                          label: productNameLabel,
                          initialValue: productManagerHelper.name,
                          onChangeConfirm: productManagerHelper.setName),
                      InformationCard(
                          label: productDescriptionLabel,
                          initialValue: productManagerHelper.description,
                          onChangeConfirm: productManagerHelper.setDescription),
                      Flexible(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sizesTitle,
                            style: theme.textTheme.headline2,
                          ),
                          InkResponse(
                            onTap: () {
                              navigationProvider.navigateToSizeManager(
                                  context, productManagerHelper.product);
                            },
                            child: Text(
                              manage,
                              style: theme.textTheme.overline,
                            ),
                          )
                        ],
                      )),
                      Expanded(
                          child: ValueListenableBuilder(
                              valueListenable: productManagerHelper.formCounter,
                              builder: (context, value, child) {
                                return OptionalItemsWidget(
                                  sizesTitle,
                                  displayTitle: false,
                                  activeItem: currentSizeIndex.value,
                                  unselectedItemColor:
                                      theme.colorScheme.background,
                                  itemCount:
                                      productManagerHelper.modelsCount.value,
                                  itemPopulater: getSize,
                                  onItemPressed: selectSize,
                                );
                              })),
                    ]),
              )
            ],
          ),
        ));
  }
}
