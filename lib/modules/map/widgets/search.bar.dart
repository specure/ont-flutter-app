import 'package:flutter/material.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';

const double mapSearchBarHeight = 48;

class MapSearchBar extends StatelessWidget {
  final FocusNode textFieldFocusNode;
  final Function? onCancelSearchTap;
  final Function? onSearchTap;
  final Function(String)? onSearchEdit;
  final bool isSearchActive;
  final List<MapSearchItem>? searchResults;
  final Function(MapSearchItem)? onSearchResultTap;

  MapSearchBar({
    required this.textFieldFocusNode,
    this.onCancelSearchTap,
    this.onSearchTap,
    this.onSearchEdit,
    this.isSearchActive = false,
    this.searchResults,
    this.onSearchResultTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: mapSearchBarHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(blurRadius: 8, color: Colors.black26),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: ConditionalContent(
                    conditional: !isSearchActive,
                    truthyBuilder: () => GestureDetector(
                      key: Key('search tap'),
                      onTap: () => onSearchTap?.call(),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        height: 48,
                        child: Text(
                          'Search by address, municipality…'.translated,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    falsyBuilder: () => TextField(
                      focusNode: textFieldFocusNode,
                      onChanged: (value) => onSearchEdit?.call(value),
                      decoration: InputDecoration(
                        hintText: 'Search'.translated,
                        hintStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: NTDimensions.textM,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              ConditionalContent(
                conditional: !isSearchActive,
                truthyBuilder: () => IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => onSearchTap?.call(),
                ),
                falsyBuilder: () => IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => onCancelSearchTap?.call(),
                ),
              ),
            ],
          ),
        ),
        ConditionalContent(
          conditional: (searchResults != null && searchResults!.length > 0) &&
              isSearchActive,
          truthyBuilder: () => _buildSearchResults(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return Container(
      key: Key('search results'),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(blurRadius: 8, color: Colors.black26),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: searchResults!.length + 1,
        itemBuilder: (context, index) => ConditionalContent(
          conditional: index == 0,
          truthyBuilder: () => Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Text(
              'Results'.translated.toUpperCase(),
              style: TextStyle(color: Colors.black54),
            ),
          ),
          falsyBuilder: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => onSearchResultTap?.call(searchResults![index - 1]),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    searchResults![index - 1].address,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: NTDimensions.textM),
                  ),
                ),
              ),
              ConditionalContent(
                conditional: index != (searchResults!.length),
                truthyBuilder: () =>
                    Container(height: 1, color: Colors.black12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
