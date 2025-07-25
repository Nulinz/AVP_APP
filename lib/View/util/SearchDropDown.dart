import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sakthiexports/Theme/Fonts.dart';

class SearchDropdownInput extends StatefulWidget {
  final String hintText, validatorText;
  final String? dropdownValue;
  final List<String> dropdownList;
  final bool validationRequired;
  final ValueChanged<String?> onChanged;

  const SearchDropdownInput({
    super.key,
    required this.hintText,
    required this.validatorText,
    this.dropdownValue,
    required this.dropdownList,
    required this.onChanged,
    this.validationRequired = true,
  });

  @override
  _SearchDropdownInputState createState() => _SearchDropdownInputState();
}

class _SearchDropdownInputState extends State<SearchDropdownInput> {
  String? dropdownValue;
  List<String> filteredList = [];

  @override
  void initState() {
    super.initState();
    dropdownValue = widget.dropdownValue;
  }

  @override
  void didUpdateWidget(SearchDropdownInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dropdownValue != dropdownValue) {
      setState(() {
        dropdownValue = widget.dropdownValue;
      });
    }
  }

  void _openSearchDropdown(BuildContext context) {
    filteredList = List.from(widget.dropdownList); // Initialize list

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController searchController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: Get.height * 0.6,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (query) {
                        setStateModal(() {
                          filteredList = widget.dropdownList
                              .where((item) => item
                                  .toLowerCase()
                                  .contains(query.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filteredList.isNotEmpty
                          ? ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  dense: true,
                                  title: Text(
                                    filteredList[index],
                                    style: AppTextStyles.body,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      dropdownValue = filteredList[index];
                                    });
                                    widget.onChanged(dropdownValue);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                "No results found",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _openSearchDropdown(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.width / 2.8,
                  child: Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    dropdownValue ?? widget.hintText,
                    style: TextStyle(
                      fontSize: 15.r,
                      color: dropdownValue == null ? Colors.grey : Colors.black,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down,
                    color: dropdownValue == null ? Colors.grey : Colors.black),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
