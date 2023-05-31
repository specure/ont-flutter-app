import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nt_flutter_standalone/core/constants/dimensions.dart';
import 'package:nt_flutter_standalone/core/widgets/conditional-content.dart';
import 'package:nt_flutter_standalone/modules/map/models/map-search.item.dart';
import 'package:nt_flutter_standalone/core/extensions/string.ext.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.cubit.dart';
import 'package:nt_flutter_standalone/modules/map/store/map.state.dart';

const double mapSearchBarHeight = 48;

class MapSearchBar extends StatelessWidget {
  MapSearchBar({FocusNode? focusNode}) {
    this.focusNode = focusNode ?? FocusNode();
  }
  late final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (context, state) => Column(
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
                      conditional: !state.isSearchActive,
                      truthyBuilder: () => GestureDetector(
                        key: Key('search tap'),
                        onTap: () =>
                            GetIt.I.get<MapCubit>().onSearchTap(focusNode),
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
                        focusNode: focusNode,
                        onChanged: (q) =>
                            GetIt.I.get<MapCubit>().onSearchEdit(q),
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
                  conditional: !state.isSearchActive,
                  truthyBuilder: () => IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () =>
                        GetIt.I.get<MapCubit>().onSearchTap(focusNode),
                  ),
                  falsyBuilder: () => IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () =>
                        GetIt.I.get<MapCubit>().onCancelSearchTap(),
                  ),
                ),
              ],
            ),
          ),
          ConditionalContent(
            conditional: (state.searchResults != null &&
                    state.searchResults!.length > 0) &&
                state.isSearchActive,
            truthyBuilder: () => _buildSearchResults(state.searchResults),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<MapSearchItem>? searchResults) {
    if (searchResults == null) {
      return Container();
    }
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
        itemCount: searchResults.length + 1,
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
                onTap: () => GetIt.I
                    .get<MapCubit>()
                    .onSearchResultTap(searchResults[index - 1]),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    searchResults[index - 1].address,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: NTDimensions.textM),
                  ),
                ),
              ),
              ConditionalContent(
                conditional: index != (searchResults.length),
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
