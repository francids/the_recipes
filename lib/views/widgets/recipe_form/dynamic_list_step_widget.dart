import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:the_recipes/gestures/drag_start_listener.dart';
import 'package:the_recipes/views/widgets/form_field.dart';

class DynamicListStepWidget extends StatefulWidget {
  final RxList<String> list;
  final String label;

  const DynamicListStepWidget({
    Key? key,
    required this.list,
    required this.label,
  }) : super(key: key);

  @override
  State<DynamicListStepWidget> createState() => _DynamicListStepWidgetState();
}

class _DynamicListStepWidgetState extends State<DynamicListStepWidget> {
  final RxInt _rebuildTrigger = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: () => widget.list.add(""),
          child: Text(tr("dynamic_list.add_item", args: [widget.label])),
        ),
        const SizedBox(height: 16),
        Obx(() => _buildListContent()),
      ],
    );
  }

  Widget _buildListContent() {
    if (widget.list.isEmpty) {
      return Center(
        child: Text(
          tr("dynamic_list.no_items_yet", args: [widget.label.toLowerCase()]),
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    _rebuildTrigger.value;

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: (oldIndex, newIndex) {
        if (newIndex > oldIndex) {
          newIndex = newIndex - 1;
        }
        final item = widget.list[oldIndex];
        final newList = List<String>.from(widget.list);
        newList.removeAt(oldIndex);
        newList.insert(newIndex, item);
        widget.list.assignAll(newList);
        _rebuildTrigger.value++;
      },
      itemCount: widget.list.length,
      itemBuilder: (context, i) => _buildListItem(i),
    );
  }

  Widget _buildListItem(int index) {
    return Container(
      key: ValueKey('item-$index-${_rebuildTrigger.value}'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => Row(
          children: [
            CustomDragStartListener(
              index: index,
              child: const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(
                  Icons.drag_handle,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: ModernFormField(
                initialValue: widget.list[index],
                onChanged: (text) => widget.list[index] = text,
                keyboardType: TextInputType.text,
                hintText: "${widget.label} ${index + 1}",
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle, color: Colors.red),
              onPressed: () => widget.list.removeAt(index),
            ),
          ],
        ),
      ),
    );
  }
}
