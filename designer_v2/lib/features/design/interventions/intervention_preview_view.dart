import 'package:flutter/material.dart';
import 'package:studyu_designer_v2/routing/router_config.dart';

class InterventionPreview extends StatelessWidget {
  const InterventionPreview({
    required this.routeArgs,
    Key? key
  }) : super(key: key);

  final InterventionFormRouteArgs routeArgs;

  @override
  Widget build(BuildContext context) {
    // TODO: provide InterventionPreviewController based on routeArgs
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.25),
              child: const Center(
                // TODO: implement InterventionPreview widget
                child: Text("[TODO InterventionPreview]")
              ),
            )
        )
      ],
    );
  }
}
