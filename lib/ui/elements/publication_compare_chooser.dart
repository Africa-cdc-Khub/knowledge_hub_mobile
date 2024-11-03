import 'package:flutter/material.dart';
import 'package:khub_mobile/models/publication_model.dart';
import 'package:khub_mobile/ui/elements/spacers.dart';
import 'package:khub_mobile/utils/l10n_extensions.dart';

class PublicationCompareChooser extends StatelessWidget {
  final PublicationModel? publicationOne;
  final PublicationModel? publicationTwo;
  final VoidCallback onTapPublicationOne;
  final VoidCallback onTapPublicationTwo;

  const PublicationCompareChooser({
    super.key,
    this.publicationOne,
    this.publicationTwo,
    required this.onTapPublicationOne,
    required this.onTapPublicationTwo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTapPublicationOne,
            child: _buildPublicationWidget(
                publicationOne, context.localized.pickPublicationOne, context),
          ),
        ),
        const SizedBox(width: 8),
        Icon(Icons.compare_arrows,
            size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: onTapPublicationTwo,
            child: _buildPublicationWidget(
                publicationTwo, context.localized.pickPublicationTwo, context),
          ),
        ),
      ],
    );
  }

  Widget _buildPublicationWidget(PublicationModel? publication,
      String placeholderText, BuildContext context) {
    if (publication != null) {
      return Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            publication.title,
            style: const TextStyle(fontSize: 14),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    } else {
      return Card(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          child: Row(
            children: [
              Icon(Icons.add_circle_outline,
                  size: 24, color: Theme.of(context).primaryColor),
              xSpacer(6),
              Text(placeholderText,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      );
    }
  }
}
