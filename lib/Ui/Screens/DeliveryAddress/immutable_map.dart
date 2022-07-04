import 'package:flutter/material.dart';
import 'package:online_order_shop_mobile/Application/DeliveryAddress/delivery_address.dart';
import 'package:online_order_shop_mobile/Application/Providers/helpers_provider.dart';
import 'package:online_order_shop_mobile/Ui/Components/buttons.dart';
import 'package:online_order_shop_mobile/Ui/Themes/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ImmutableDeliveryAddresScreen extends StatefulWidget {
  final double _mapZoom = 13;
  final double _markerHeight = 80;
  final double latitude;
  final double longitude;
  final double _markerWidth = 80;
  final double _markerSize = 50.0;
  final Key _markerKey = const Key("marker");
  const ImmutableDeliveryAddresScreen(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeliveryAddresState();
}

class _DeliveryAddresState extends State<ImmutableDeliveryAddresScreen> {
  late LatLng location;

  void setup() {
    location = LatLng(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    setup();

    DeliveryAddress _address =
        Provider.of<HelpersProvider>(context, listen: false).addressHelper;

    ThemeData theme = Theme.of(context);

    return FutureBuilder(
      future: _address.initGpsLocation(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              body: FlutterMap(
            options: MapOptions(
              center: location,
              zoom: widget._mapZoom,
            ),
            nonRotatedChildren: [
              TileLayerWidget(
                  options: TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'])),
              MarkerLayerWidget(
                  key: widget._markerKey,
                  options: MarkerLayerOptions(markers: [
                    Marker(
                      width: widget._markerWidth,
                      height: widget._markerHeight,
                      rotate: false,
                      anchorPos: AnchorPos.align(AnchorAlign.center),
                      point: location,
                      builder: (ctx) => Icon(
                        Icons.add_location_alt,
                        size: widget._markerSize,
                        color: theme.colorScheme.primary,
                      ),
                    )
                  ]))
            ],
          ));
        }
        if (snapshot.hasError) {
          return Container(
            color: theme.colorScheme.surface,
            child: Center(
              child: DefaultButton(
                text: buttonRequestGpsPermissions,
                onPressed: () {
                  _address.requestGpsPermissions(context);
                },
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
