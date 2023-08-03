import 'package:flutter/material.dart';

class MySizedBox extends StatefulWidget {

  final double? height;
  final double? width;
  const MySizedBox({super.key, this.height, this.width});

  @override
  State<MySizedBox> createState() => _MySizedBoxState();
}

class _MySizedBoxState extends State<MySizedBox> {
  @override
  Widget build(BuildContext context) {
    double ratio =0;
    final size = MediaQuery.of(context).size;

    sizedBoxHandler(){
      if(widget.height != null){
        setState(() {
          ratio = widget.height! / size.height;
        });
        return size.height*ratio;
      }
      else if(widget.width != null){
         setState(() {
          ratio = widget.width! / size.width;
        });
        return size.width * ratio;
      }
      else{
        return 0;
      }
    }
    return SizedBox();
  }
}