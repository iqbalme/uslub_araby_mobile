import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  SearchBarWidgetState createState() => SearchBarWidgetState();
}

class SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  late UslubProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = Provider.of<UslubProvider>(context, listen: false);
    _provider.addListener(_onProviderChanged);
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onProviderChanged() {
    if (_provider.searchText.isNotEmpty &&
        _provider.searchText != _controller.text) {
      _controller.text = _provider.searchText;
      // Clear searchText after setting it to controller
      _provider.clearSearchText();
    }
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isNotEmpty) {
      Provider.of<UslubProvider>(
        context,
        listen: false,
      ).searchAndSave(query.trim());
    }
  }

  void _onClear() {
    _controller.clear();
    Provider.of<UslubProvider>(context, listen: false).clearSearch();
  }

  void setSearchTextAndSubmit(String text) {
    _controller.text = text;
    _onSearchSubmitted(text);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, child) {
        return TextField(
          controller: _controller,
          autocorrect: false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Cari Uslub...',
            hintStyle: const TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            border:
                InputBorder.none, // Remove border since it's handled by parent
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white70),
                    onPressed: _onClear,
                  )
                : null,
          ),
          onSubmitted: _onSearchSubmitted,
        );
      },
    );
  }
}
