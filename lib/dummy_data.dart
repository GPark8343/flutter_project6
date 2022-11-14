var BAR_PLACES = DUMMY_PLACES.where((e) => e["type"] == "bar");

var RESTAURANT_PLACES = DUMMY_PLACES.where((e) => e["type"] == "restaurant");

var CAFE_PLACES = DUMMY_PLACES.where((e) => e["type"] == "cafe");

var DUMMY_PLACES = [
  {
    "place_id": "1",
    "name": "막걸리찬가",
    "geometry": {
      "location": {"lat": 37.58365719999999, "lng": 127.0290684},
      "address": "1층"
    },
    "distance": 100,
    "type": "bar"
  },
  {
    "place_id": "2",
    "name": "고연전포차",
    "geometry": {
      "location": {"lat": 37.585144, "lng": 127.0295122},
      "address": "지하 1층"
    },
    "distance": 10,
    "type": "bar"
  },
  {
    "place_id": "3",
    "name": "맥도날드",
    "geometry": {
      "location": {"lat": 37.5844210, "lng": 127.029234},
      "address": "1층, 2층"
    },
    "distance": 10000,
    "type": "restaurant"
  },{
    "place_id": "4",
    "name": "스타벅스 고대점",
    "geometry": {
      "location": {"lat": 37.5839163, "lng": 127.029687},
      "address": "1층, 2층"
    },
    "distance": 100000,
    "type": "cafe"
  },
];
