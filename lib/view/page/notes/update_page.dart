import 'package:flutter/material.dart';
import 'package:notely/view/util/app_bar_note_widget.dart';
import '../../../controller/note_controller.dart';
import '../../../controller/update_or_create_controller.dart';

class UpdateOrCreatePage extends StatefulWidget {
  UpdateOrCreateController updateController = UpdateOrCreateController();
  NoteController noteController = NoteController();

  /// updateOrCreate = 0 ==> update this means that the id must be set.
  /// updateOrCreate = 1 ==> create this means that the id mustn't be set.
  UpdateOrCreatePage({super.key, String? id, required int updateOrCreate} ) {
    updateController.updateOrCreate = updateOrCreate;
    if(updateOrCreate == 0) {
      updateController.id = id!;
      updateController.noteModel = noteController.note;
      updateController.addedUsers = noteController.note.users;
      updateController.nameController.text = noteController.note.name;
      updateController.infoController.text = noteController.note.info;
    }else{
      updateController.initNote();
      updateController.nameController.text = "Example Name";
      updateController.infoController.text = "Example Text";
    }
  }
  @override
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<UpdateOrCreatePage> {
  UpdateOrCreateController updateController = UpdateOrCreateController();

  ///bool isEnabled = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build / design Page nice
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBarNote(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    autofocus: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    focusNode: updateController.textNode,
                    controller: updateController.infoController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 17,
                    onTap: () {
                      updateController.draggableScrollableController.animateTo(
                          0.1,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                      setState(() {
                        updateController.isExpanded = false;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      ///isEnabled = false;
                    });
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              setState(() {
              });
            },
            child: DraggableScrollableSheet(
              initialChildSize: updateController.initialExtent,
              minChildSize: updateController.minChildSize,
              maxChildSize: updateController.maxChildSize,
              controller: updateController.draggableScrollableController,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35)),
                    color: Colors.blue[100],
                  ),
                  padding: const EdgeInsets.all(15),
                  child: groupButton(scrollController, 50, 50),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget groupButton(
      ScrollController scrollController, double height, double width) {
    return ListView(
      controller: scrollController,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hintergrundfarbe"),
            Row(
              children: buttonBackgroundColorGroup(scrollController, height, width),
            ),
          ],
        ),
        const SizedBox(
          height: 400,
        ),
      ],
    );
  }

  List<Widget> buttonBackgroundColorGroup(ScrollController scrollController, double height, double width){
    List<Widget> buttonChildrens = [];
    for (int i = 0; i < updateController.colors.length - 1; i++) {
      Widget gestureDetector = Container(
        margin: const EdgeInsets.all(3),
        child: GestureDetector(
          onTap: () {
            updateController.isCardEnabled.replaceRange(
                0, updateController.isCardEnabled.length, [
              for (int i = 0; i < updateController.isCardEnabled.length; i++)
                false
            ]);
            updateController.isCardEnabled[i] = true;
            updateController.backgroundColors
                .replaceRange(0, updateController.backgroundColors.length, [
              for (int i = 0; i < updateController.backgroundColors.length; i++)
                const Color(0xeae5e5e5)
            ]);
            updateController.backgroundColors[i] = const Color(0xea196ccc);
            setState(() {
              updateController.initialExtent = updateController.isExpanded ? updateController.maxChildSize : updateController.minChildSize;
            });
            print("$i ${updateController.colors[i]}");
          },
          child: Container(
            width: width,
            height: height,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: updateController.backgroundColors[i]),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: updateController.colors[i],
              ),
            ),
          ),
        ),
      );

      buttonChildrens.add(gestureDetector);
    }
    buttonChildrens.add(
      GestureDetector(
        onTap: () {
          updateController.isCardEnabled.replaceRange(
              0, updateController.isCardEnabled.length, [
            for (int i = 0; i < updateController.isCardEnabled.length; i++)
              false
          ]);
          updateController.isCardEnabled[4] = true;
          updateController.backgroundColors
              .replaceRange(0, updateController.backgroundColors.length, [
            for (int i = 0; i < updateController.backgroundColors.length; i++)
              const Color(0xeae5e5e5)
          ]);
          updateController.backgroundColors[4] = const Color(0xea196ccc);
          setState(() {
            updateController.initialExtent = updateController.isExpanded ? updateController.maxChildSize : updateController.minChildSize;
          });
          print("4 ${updateController.colors[4]}");
        },
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: updateController.backgroundColors[4]),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: updateController.colors[4],
            ),
            child: Icon(
              Icons.restart_alt_outlined,
              color: updateController.isCardEnabled[4]
                  ? updateController.backgroundColors[4]
                  : const Color(0xff363535),
            ),
          ),
        ),
      ),
    );
    buttonChildrens.add(
      GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          scrollController.animateTo(400,
              duration: const Duration(microseconds: 500),
              curve: Curves.easeInOut);
          updateController.draggableScrollableController.animateTo(0.5,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
          updateController.draggableScrollableController.isAttached;
          setState(() {
            updateController.isExpanded = true;
            updateController.initialExtent = updateController.isExpanded ? updateController.maxChildSize : updateController.minChildSize;
          });
        },
        child: const Icon(
          Icons.more_vert_rounded,
          color: Color(0xff232222),
          size: 40,
        ),
      ),
    );
    return buttonChildrens;
  }
}
