import 'package:flutter/material.dart';


class HectarsScreen extends StatelessWidget {
  const HectarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: Stack(
        children: [

          /// MAIN CONTENT
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                const Text(
                  "Hectars for IAs",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                /// LIST
                Expanded(
                  child: Wrap(
                    spacing: 40,
                    runSpacing: 20,
                    children: const [

                      HectarCard(
                        date: "January 01, 2026 - 2:36 pm",
                        value: "10",
                      ),

                      HectarCard(
                        date: "January 05, 2026 - 2:40 pm",
                        value: "10",
                      ),

                      HectarCard(
                        date: "January 03, 2026 - 2:40 pm",
                        value: "10",
                      ),

                      HectarCard(
                        date: "January 04, 2026 - 2:40 pm",
                        value: "10",
                      ),

                      HectarCard(
                        date: "January 04, 2026 - 3:40 pm",
                        value: "10",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// FLOATING ADD BUTTON (Top Right)
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                  )
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ); 
  }
}

class HectarCard extends StatelessWidget {
  final String date;
  final String value;

  const HectarCard({
    super.key,
    required this.date,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// DATE TEXT
          Text(
            date,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          /// VALUE BOX
          Container(
            width: 150,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF9FD3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}