import 'package:mot3lqat/src/pages/cards_page/hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class IdWidget extends StatelessWidget {
  const IdWidget({super.key, required this.IdData});

  final Id IdData;



  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      side: CardSide.FRONT,
      front: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
        margin: const EdgeInsets.fromLTRB(13, 10, 13, 10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.brown,
            ),
            color: Colors.brown,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.fromLTRB(30, 0, 0, 10),
              alignment: Alignment.centerLeft,
              child: const Icon(
                Icons.face_outlined,
                color: Colors.white,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                IdData.cardHolderName,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  IdData.Addres
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                IdData.cardNumber,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child:
                  Container(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        const Text(
                          'DateOfBirth',
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize:20
                          ),
                        ),
                        Text(
                          style: const TextStyle(color: Colors.white60,
                              fontSize: 20),
                          IdData.DateOfBirth,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      back: Container(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
        height: 195,
        width: 90,
        decoration: const BoxDecoration(
            color: Colors.brown,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              child: const Text(
                'VALID THRU ',
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(

                style: const TextStyle(color: Colors.white,fontSize: 20),
                IdData.ExpiryDate,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child:
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        const Text(
                          'DateOfBirth',
                          style: TextStyle(
                              color: Colors.white60,
                              fontSize:20
                          ),
                        ),
                        Text(
                          style: const TextStyle(color: Colors.white60,
                              fontSize: 20),
                          IdData.DateOfBirth,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );

  }

}
