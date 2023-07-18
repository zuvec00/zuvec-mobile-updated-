import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TestTab extends StatelessWidget {
  const TestTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: MasonryGridView.builder(
                itemCount: 4,
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                itemBuilder: ((context, index) {
                  return Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Container(
                              height: 130,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(7.5)),
                              child:
                                  Image.asset('lib/assets/connect_intro.png')),
                          const Text(
                            'N15000',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            'Just Testing something with the tab ui',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 14),
                          )
                        ],
                      ));
                })))
      ],
    );
  }
}
