import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchableDropdown extends StatefulWidget {
  final String hintText;
  final Icon prefixIcon;
  final String? value;
  final void Function(String?) onChanged;
  final String? Function(String?)? validator;
  final bool isLoading;

  const SearchableDropdown({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.value,
    required this.onChanged,
    this.validator,
    this.isLoading = false,
  });

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showDropdown = false;
  List<String> _allTeams = [];
  List<String> _filteredTeams = [];
  bool _isLoading = false;
  String? _selectedTeam;  // Track the selected team separately

  @override
  void initState() {
    super.initState();
    _fetchTeams();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showDropdown = true;
        });
      }
    });

    // If a value is provided, set it in the search controller
    if (widget.value != null && widget.value!.isNotEmpty) {
      _searchController.text = widget.value!;
      _selectedTeam = widget.value;
    }
  }

  @override
  void didUpdateWidget(SearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _selectedTeam) {
      _searchController.text = widget.value ?? '';
      _selectedTeam = widget.value;
    }
  }

  Future<void> _fetchTeams() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch teams from Firebase Realtime Database
      DatabaseReference teamsRef = FirebaseDatabase.instance.ref("trikon2025").child("teamNames").child('teams');
      DataSnapshot snapshot = await teamsRef.get();

      List<String> teams = [];
      if (snapshot.exists && snapshot.value != null) {
        if (snapshot.value is List) {
          // If the data is stored as a list in Firebase
          List<dynamic> teamsList = snapshot.value as List<dynamic>;
          teams = teamsList.where((item) => item != null).map((item) => item.toString()).toList();
        } else if (snapshot.value is Map) {
          // If the data is stored as a map in Firebase
          Map<dynamic, dynamic> teamsMap = snapshot.value as Map<dynamic, dynamic>;
          teams = teamsMap.values.where((item) => item != null).map((item) => item.toString()).toList();
        }
      }

      setState(() {
        _allTeams = teams;
        _filteredTeams = List.from(_allTeams);
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching teams: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterTeams(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredTeams = List.from(_allTeams);
      });
    } else {
      setState(() {
        _filteredTeams = _allTeams
            .where((team) => team.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                widget.onChanged(null);
                _selectedTeam = null;
                _filterTeams('');
              },
            )
                : const Icon(Icons.arrow_drop_down),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          readOnly: true,
          onTap: () {
            setState(() {
              _showDropdown = !_showDropdown;
            });
          },
          validator: widget.validator,
        ),
        if (_showDropdown)
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            constraints: const BoxConstraints(
              maxHeight: 200,
            ),
            child: _isLoading || widget.isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search team...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                    onChanged: _filterTeams,
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _filteredTeams.isEmpty
                      ? const Center(
                    child: Text('No teams found'),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredTeams.length,
                    itemBuilder: (context, index) {
                      final team = _filteredTeams[index];
                      return ListTile(
                        dense: true,
                        title: Text(team),
                        onTap: () {
                          setState(() {
                            _searchController.text = team;
                            _selectedTeam = team;
                            _showDropdown = false;
                          });
                          widget.onChanged(team);
                          FocusScope.of(context).unfocus();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}