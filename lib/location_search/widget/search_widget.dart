// import 'package:widgets/custom_text_field.dart';
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:single_af/constants/colors.dart';
// import '../../CONSTANT/COLORS.dart';
import '../utils/google_search/geo_coding.dart';
import '../utils/google_search/latlng.dart';
import 'dart:convert';
import '../utils/google_search/place.dart';
import '../utils/google_search/place_type.dart';


class SearchLocation extends StatefulWidget {
  //final Key ? key;

  /// API Key of the Google Maps API.
  final String  apiKey;
  //text change im search
  final void Function(String value) ? onChangeText;

  final void Function() ? onClearIconPress;

  /// Placeholder text to show when the user has not entered any input.
  final String placeholder;

  final BoxDecoration? boxDecoration;
   final dynamic value;
  /// The callback that is called when one Place is selected by the user.
  final void Function(Place place) ? onSelected;

  /// The callback that is called when the user taps on the search icon.
  final void Function(Place place) ? onSearch;

  /// Language used for the autocompletion.
  ///
  /// Check the full list of [supported languages](https://developers.google.com/maps/faq#languagesupport) for the Google Maps API
  final String language;

  /// set search only work for a country
  ///
  /// While using country don't use LatLng and radius
  final String ? country;

  /// The point around which you wish to retrieve place information.
  ///
  /// If this value is provided, `radius` must be provided aswell.
  final LatLng ? location;

  /// The distance (in meters) within which to return place results. Note that setting a radius biases results to the indicated area, but may not fully restrict results to the specified area.
  ///
  /// If this value is provided, `location` must be provided aswell.
  ///
  /// See [Location Biasing and Location Restrict](https://developers.google.com/places/web-service/autocomplete#location_biasing) in the documentation.
  final int ? radius;

  /// Returns only those places that are strictly within the region defined by location and radius. This is a restriction, rather than a bias, meaning that results outside this region will not be returned even if they match the user input.
  final bool strictBounds;

  /// Place type to filter the search. This is a tool that can be used if you only want to search for a specific type of location. If this no place type is provided, all types of places are searched. For more info on location types, check https://developers.google.com/places/web-service/autocomplete?#place_types
  final PlaceType ? placeType;

  /// The initial icon to show in the search box
  final IconData icon;

  /// Makes available "clear textfield" button when the user is writing.
  final bool hasClearButton;

  /// The icon to show indicating the "clear textfield" button
  final IconData clearIcon;

  /// The color of the icon to show in the search box
  final Color iconColor;

  /// Enables Dark Mode when set to `true`. Default value is `false`.
  final bool darkMode;

   final double? height;
   final TextStyle? hintStyle;
   final String initialData;
   final FocusNode? focusNode;

  SearchLocation({
    this.focusNode,
    required this.apiKey,
    this.initialData = '',
    this.placeholder = 'Search',
    this.icon = Icons.search,
    this.hasClearButton = true,
    this.clearIcon = Icons.clear,
    this.iconColor = Colors.black26,
    this.onSelected,
    this.onSearch,
    this.onChangeText,
    this.onClearIconPress,
    this.language = 'en',
    this.country,
    this.location,
    this.radius,
    this.strictBounds = false,
    this.placeType,
    this.darkMode = false,
    this.boxDecoration,
    this.height,
    this.hintStyle,
    this.value,
    Key ? key,
  }): super(key: key);

  @override
  SearchLocationState createState() => SearchLocationState(this.focusNode??FocusNode());
}

class SearchLocationState extends State<SearchLocation> with TickerProviderStateMixin{
  TextEditingController _textEditingController = TextEditingController();
  late AnimationController  _animationController;
  // SearchContainer height.
  Animation ? _containerHeight;
  // Place options opacity.
  Animation? _listOpacity;

  List<dynamic> _placePredictions = [];
  bool _isEditing = false;
  Geocoding ? geocode;

  String _tempInput = "";
  String _currentInput = "";

  FocusNode fn;

  late CrossFadeState  _crossFadeState;


  SearchLocationState(this.fn);

  updateTextField(String text){
    _textEditingController.text = text;
    Future.delayed(const Duration(milliseconds: 1000)).then((value){
      closeSearch();
      setState(() {

      });
    });
    setState(() {

    });
  }

  @override
  void initState() {
    _textEditingController.text = widget.initialData;
    geocode = Geocoding(apiKey: widget.apiKey, language: widget.language);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _containerHeight = Tween<double>(begin: widget.height??65, end: 364).animate(
      CurvedAnimation(
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );
    _listOpacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
        parent: _animationController,
      ),
    );

    _textEditingController.addListener(_autocompletePlace);
    customListener();

    if (widget.hasClearButton) {
      fn.addListener(() async {
        if (fn.hasFocus)
          setState(() => _crossFadeState = CrossFadeState.showSecond);
        else
          setState(() => _crossFadeState = CrossFadeState.showFirst);
      });
      _crossFadeState = CrossFadeState.showFirst;
    }

    super.initState();
  }

  void _autocompletePlace() async {
    if (fn.hasFocus) {
      setState(() {
        _currentInput = _textEditingController.text;
        _isEditing = true;
      });

      _textEditingController.removeListener(_autocompletePlace);

      if (_currentInput.length == 0) {
        if (!_containerHeight!.isDismissed) closeSearch();
        _textEditingController.addListener(_autocompletePlace);
        return;
      }

      if (_currentInput == _tempInput) {
        final predictions = await _makeRequest(_currentInput);
        await _animationController.animateTo(0.5);
        setState(() => _placePredictions = predictions);
        await _animationController.forward();

        _textEditingController.addListener(_autocompletePlace);
        return;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        _textEditingController.addListener(_autocompletePlace);
        if (_isEditing == true) _autocompletePlace();
      });
    }
  }

  Future<dynamic> _makeRequest(input) async {
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${widget.apiKey}&language=${widget.language}";
    if (widget.location != null && widget.radius != null) {
      url += "&location=${widget.location!.latitude},${widget.location!.longitude}&radius=${widget.radius}";
      if (widget.strictBounds) {
        url += "&strictbounds";
      }
    }

    if (widget.placeType != null) {

      url += "&types=${widget.placeType!.apiString}";

    }

    if(widget.country != null){

      url += "&components=country:${widget.country}";

    }

    final response = await http.get(Uri.parse(url));
    final extractedData = json.decode(response.body);

    if (extractedData["error_message"] != null) {
      var error = extractedData["error_message"];
      if (error == "This API project is not authorized to use this API.")
        error += " Make sure the Places API is activated on your Google Cloud Platform";
      throw Exception(error);
    } else {
      final predictions = extractedData["predictions"];
      return predictions;
    }
  }

  void _selectPlace({Place ? prediction}) async {
    if (prediction != null) {
      _textEditingController.value = TextEditingValue(
        text: prediction.description,
        selection: TextSelection.collapsed(
          offset: prediction.description.length,
        ),
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
    }

    // Makes animation
    closeSearch();

    // Calls the `onSelected` callback
    if (prediction is Place) widget.onSelected!(prediction);
  }

  void closeSearch() async {
    if (!_animationController.isDismissed) await _animationController.animateTo(0.5);
    fn.unfocus();
    setState(() {
      _placePredictions = [];
      _isEditing = false;
    });
    _animationController.reverse();
    _textEditingController.addListener(_autocompletePlace);
  }

  void customListener() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if(mounted){
        setState((){
          _tempInput = _textEditingController.text;
        });
        customListener();
      }

    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textEditingController.dispose();
    fn.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 36,
      // height: widget.height??36,
      width: MediaQuery.of(context).size.width,
      child: _searchContainer(

        child: _searchInput(context),
      ),
    );
  }

  Widget _searchContainer({@required Widget ? child}) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Container(
            height: _containerHeight!.value,
            decoration: _containerDecoration(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12.0, right: 12.0, top: widget.height==null?0:(widget.height!-38)/2,),
                  child: child,
                ),
                if (_placePredictions.length > 0)
                  Opacity(
                    opacity: _listOpacity!.value,
                    child: Column(
                      children: <Widget>[
                        for (var prediction in _placePredictions)
                          _placeOption(Place.fromJSON(prediction, geocode!)),
                      ],
                    ),
                  ),
              ],
            ),
          );
        });
  }

  Widget _placeOption(Place prediction) {
    String place = prediction.description;

    return MaterialButton(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      onPressed: () => _selectPlace(prediction: prediction),
      child: ListTile(
        title: Text(
          place.length < 45 ? "$place" : "${place.replaceRange(45, place.length, "")} ...",
          style: TextStyle(
            // fontSize: MediaQuery.of(context).size.width * 0.04,
            fontSize: 15,
            color: widget.darkMode ? Colors.grey[100] : Colors.grey[850],
          ),
          maxLines: 1,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 0,
        ),
      ),
    );
  }

  BoxDecoration _containerDecoration() {
    return widget.boxDecoration??BoxDecoration(
      color: widget.darkMode ? Colors.grey[800] : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, spreadRadius: 10)],
    );
  }

  Widget _searchInput(BuildContext context) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: TextField(

              onChanged: (value){
                if(widget.onChangeText!=null){
                  widget.onChangeText!(value);
                }

              },

              controller: _textEditingController,
              onSubmitted: (_) => _selectPlace(),
              onEditingComplete: _selectPlace,
              autofocus: false,
              focusNode: fn,
              decoration: _inputStyle(),
              style: TextStyle(
                // fontSize: MediaQuery.of(context).size.width * 0.04,
                fontSize: 15,
                color: widget.darkMode ? Colors.grey[100] : Colors.grey[850],
              ),
            ),
          ),
          Container(width: 8),
          if (widget.hasClearButton)
            GestureDetector(
              onTap: () {
                if (_crossFadeState == CrossFadeState.showSecond){
                  _textEditingController.clear();
                  widget.onClearIconPress!();
                }
              },
              // child: Icon(_inputIcon, color: this.widget.iconColor),
              child: AnimatedCrossFade(
                crossFadeState: _crossFadeState,
                duration: const Duration(milliseconds: 300),
                firstChild: Padding(
                  padding: EdgeInsets.only(top: widget.height==null?0:(widget.height!-46)/2),
                  child: Icon(widget.icon, color: widget.iconColor.withOpacity(0.0)),
                ),
                secondChild: Icon(Icons.clear, color: widget.iconColor, size:16,),
              ),
            )
          // else
          //   Container(
          //     width: 0,
          //   ),
          // // if (!widget.hasClearButton) Padding(
          // //   padding: EdgeInsets.only(top: widget.height==null?0:(widget.height!-40)/2),
          // //   child: Icon(widget.icon, color: widget.iconColor),
          // // )
        ],
      ),
    );
  }

  InputDecoration _inputStyle() {
    return InputDecoration(
      isDense: true,
      hintText: this.widget.placeholder,
      border: InputBorder.none,
      contentPadding: const EdgeInsets.only(top: 20),
      hintStyle: widget.hintStyle??TextStyle(
        fontSize: 16,
        color:  widget.iconColor,
      ),
    );
  }

}
