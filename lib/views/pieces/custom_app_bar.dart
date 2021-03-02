import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onTap;
  final bool isReturnIconEnabled;
  @override
  final Size preferredSize;

  CustomAppBar({this.title, this.onTap, this.isReturnIconEnabled = false}) : preferredSize = Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> {
        this.onTap()
      },
      child: SafeArea(
        child:
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.91,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if(isReturnIconEnabled) returnIcon(context),
                              Center(
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 20,
                                      // color: Colors.black54,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }
}

Widget returnIcon(BuildContext context) {
  return GestureDetector(
    child: Icon(
        Icons.reply
    ),
    onTap: () {
      Navigator.pop(context);
    },
  );
}