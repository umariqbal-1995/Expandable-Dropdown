library expandable_dropdown;


import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';


class ExpandableDropDown extends StatefulWidget {
  ExpandableDropDown({Key? key, required this.items, required this.selectedItem, required this.onChange, required this.value,required this.isExpanded, this.barDecoration,this.childDecoration, this.textStyle}) : super(key: key);
  String value;
  final List<String> items;
  final String selectedItem;
  final ValueSetter<String> onChange;
  bool isExpanded;
  Decoration? barDecoration;
  Decoration? childDecoration;
  TextStyle? textStyle;



  @override
  State<ExpandableDropDown> createState() => _ExpandableDropDownState();

}

class _ExpandableDropDownState extends State<ExpandableDropDown> with TickerProviderStateMixin{
  late AnimationController animationController;
  late AnimationController  iconAnimationController;
  late Animation<double> animation;
  late Animation<double> iconAnimation;

  final TextEditingController searchEditController = TextEditingController();


  final Duration _kExpand = Duration(milliseconds: 200);

  @override
  void initState() {
    // TODO: implement initState
    animationController = AnimationController(duration: _kExpand,vsync: this);
    iconAnimationController  = AnimationController(vsync: this, duration: _kExpand, upperBound: 0.5,);

    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    iconAnimation = CurvedAnimation(
        parent: iconAnimationController,
        curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tileList =[];
    for(int i=0;i<widget.items.length;i++){
      if(i==widget.items.length-1){
        tileList.add(SizedBox(height: 6,));
      }
      if(i == 0){
        tileList.add(
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45)
                    )
                ),
                controller: searchEditController,
                onChanged: (String value){
                  setState(() {

                  });
                },
              ),
            )
        );
      }
      if(widget.items[i].toLowerCase().contains(searchEditController.text.toLowerCase()))
      {
        tileList.add(GestureDetector(
          onTap: (){
            if(widget.isExpanded) {
              animationController.forward();
              iconAnimationController.forward();
            }else{
              animationController.reverse();
              iconAnimationController.reverse();
            }
            widget.value =widget.items[i];
            widget.onChange(widget.value);
          },
          child: Container(
            height: 40,
            decoration: widget.childDecoration ?? BoxDecoration(
                color: Colors.white,
                borderRadius:i==widget.items.length-1? BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10)):null
            ),
            child: Row(
              mainAxisAlignment:  MainAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 10)),
                Container(
                  height: 30,
                  child: Text(
                    widget.items[i],
                  ),
                )
              ],
            ),
          ),
        ));
      }
    }
    return Container(


      decoration:widget.barDecoration ?? BoxDecoration(
          color: Colors.white,
          boxShadow: kElevationToShadow[4],
          borderRadius: BorderRadius.all(Radius.circular(10 ))
      ),
      child: Column(
        children: [
          GestureDetector(
              child: Container(
                width: double.infinity,

                decoration: widget.barDecoration ??BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.all(Radius.circular(10 ))
                ),
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      widget.value, style: widget.textStyle),
                    //SizedBox(width: 100,),
                    const Spacer(),
                    Padding(padding: EdgeInsets.only(bottom: 6),
                        child: RotationTransition(
                          turns:Tween(begin: 0.0, end: 1.0).animate(iconAnimationController),
                          child: const RotatedBox(
                            quarterTurns: 3,
                            child: Icon(Icons.arrow_back_ios,size: 15,),
                          ),
                        )

                    ),
                  ],
                ),
              ),
              onTap:(){
                widget.onChange(widget.value);
                if(widget.isExpanded) {
                  animationController.forward();
                  iconAnimationController.forward();
                }else{
                  animationController.reverse();
                  iconAnimationController.reverse();
                }
              }
          ),
          SizeTransition(
              axisAlignment: 1.0,
              sizeFactor:animation,
              child: Column(
                children: tileList,
              )
          )
        ],
      ),
    );
  }
}
