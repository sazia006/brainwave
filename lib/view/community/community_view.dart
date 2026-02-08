import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../viewmodel/community_viewmodel.dart'; // Import ViewModel

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final CommunityViewModel _viewModel = CommunityViewModel();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        if (_viewModel.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.softGreen),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.cream, // Keep consistent background
          appBar: AppBar(
            title: const Text(
              "Community Hub",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Placeholder for Create Group feature
                },
              ),
            ],
          ),
          body: _viewModel.groups.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _viewModel.groups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final group = _viewModel.groups[index];
                    return _GroupTile(
                      name: group['name'] ?? 'Unnamed Group',
                      description: group['description'] ?? 'No description',
                      members: group['members'] ?? 0,
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.groups, size: 80, color: AppColors.softGreen),
          SizedBox(height: 16),
          Text(
            "Community Hub",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text("Study groups & discussions"),
        ],
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final String name;
  final String description;
  final int members;

  const _GroupTile({
    required this.name,
    required this.description,
    required this.members,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.softGreen.withOpacity(0.2),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : "?",
              style: const TextStyle(
                color: AppColors.softGreen,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              Text(
                "$members",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
