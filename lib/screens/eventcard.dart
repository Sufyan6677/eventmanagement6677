import 'package:eventmanagement/widgets/textwidgets.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  // final String description;
  final VoidCallback onTap;
  final String eventlocation;
  final int attendeescount;
  

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.eventlocation,
    // required this.description,
    required this.onTap,
    required this.attendeescount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,

        margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top image with date & heart icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Image.network(
                    "https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch}/400/200",
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                ),
                // Date tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: GoogleText(
                      date,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),

                // Heart icon
              ],
            ),

            // Bottom info
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GoogleText(title, fontSize: 20, fontWeight: FontWeight.bold),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: GoogleText(
                          eventlocation,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 118, 115, 115),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      GoogleText('$attendeescount attending'),
                      SizedBox(width: 45),
                      GoogleText(
                        "Join",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
