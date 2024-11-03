import 'package:flutter/material.dart';
import 'package:khub_mobile/main.dart';
import 'package:khub_mobile/themes/main_theme.dart';
import 'package:khub_mobile/ui/elements/dialogs/info_dialog.dart';
import 'package:khub_mobile/ui/screens/account/knowledgehubs/knowledge_hub_view_model.dart';
import 'package:khub_mobile/ui/screens/auth/auth_view_model.dart';
import 'package:provider/provider.dart';

class KnowledgeHubsScreen extends StatefulWidget {
  const KnowledgeHubsScreen({super.key});

  @override
  State<KnowledgeHubsScreen> createState() => _KnowledgeHubsScreenState();
}

class _KnowledgeHubsScreenState extends State<KnowledgeHubsScreen> {
  late KnowledgeHubViewModel viewModel;
  late AuthViewModel authViewModel;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<KnowledgeHubViewModel>(context, listen: false);
    authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    viewModel.fetchKnowledgeHubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        shadowColor: MainTheme.appColors.neutralBg,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Knowledge Hubs Portals",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Consumer<KnowledgeHubViewModel>(
        builder: (context, model, child) {
          if (model.state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: viewModel.state.knowledgeHubs.length,
            itemBuilder: (context, index) {
              final hub = viewModel.state.knowledgeHubs[index];
              return KnowledgeHubTile(
                hub: hub,
                isActive: hub.isActive,
                onTap: () => _setKnowledgeHub(hub),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _setKnowledgeHub(KnowledgeHubModel hub) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => InfoDialog(
          title: 'Warning',
          icon: Icons.info,
          isLoading: isLoading,
          titleBackgroundColor: MainTheme.appColors.orange500,
          confirmBackgroundColor: MainTheme.appColors.orange500,
          content:
              'By changing the knowledge hub, you will be logged out. You will be expected to login again.',
          onConfirm: () {
            _logout(hub);
            setState(() {});
          },
          onCancel: () {},
        ),
      ),
    );
  }

  void _logout(KnowledgeHubModel hub) async {
    setState(() {
      isLoading = true;
    });
    final success = await authViewModel.logout();
    setState(() {
      isLoading = false;
    });
    if (success && mounted) {
      // Rebuild the app
      final success = await viewModel.setKnowledgeHub(hub);
      if (success && mounted) {
        RestartWidget.restartApp(context);
      }
    }
  }
}

class KnowledgeHubTile extends StatelessWidget {
  final KnowledgeHubModel hub;
  final bool isActive;
  final VoidCallback onTap;

  const KnowledgeHubTile({
    super.key,
    required this.hub,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: isActive
              ? Border.all(color: Theme.of(context).primaryColor, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                hub.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (isActive)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
