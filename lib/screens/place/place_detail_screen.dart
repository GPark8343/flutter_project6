import 'package:flutter/material.dart';
import 'package:ifc_project1/helper/location_helper.dart';
import 'package:ifc_project1/providers/place/filter.dart';
import 'package:ifc_project1/providers/place/rating.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatefulWidget {
  static const routeName = '/place-detail';

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final _ratingController = TextEditingController(text: '5.0');

  void _startAddNewStar(BuildContext ctx) {
    final rating = Provider.of<Rating>(context, listen: false);

    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10),
            child: TextFormField(
              controller: _ratingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter rating',
                labelText: 'Enter rating',
                suffixIcon: MaterialButton(
                  onPressed: () {
                    rating.submitData(context, _ratingController);
                  },
                  child: Text('Rate'),
                ),
              ),
            ),
          ),
          behavior: HitTestBehavior.opaque, //background만 눌러서 모델 닫히게 하기
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments;
    final selectedPlaces = Provider.of<Filter>(context).findById(id);
    String? _previewImageUrl;

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlaces['name']),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.asset(
              './assets/images/${selectedPlaces['type']}.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            selectedPlaces["geometry"]['address'],
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () => _startAddNewStar(context),
                  child: Text('별점 달기')),
              ElevatedButton(onPressed: () {}, child: Text('리뷰 달기')),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 170,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey)),
              child: Image.network(
                LocationHelper.generateLocationPreviewImage(
                    latitude: selectedPlaces['geometry']['location']['lat'],
                    longitude: selectedPlaces['geometry']['location']['lng']),
                fit: BoxFit.cover,
                width: double.infinity,
              )),
        ],
      ),
    );
  }
}
