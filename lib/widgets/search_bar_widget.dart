import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uslub_araby/providers/uslub_provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    Provider.of<UslubProvider>(context, listen: false).search(query);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: 'Cari makna...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              _onSearchChanged('');
            },
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
