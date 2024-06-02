part of dashboard;
class _ProfilTile extends GetView<DashboardController> {
  const _ProfilTile(
      {required this.onPressedNotification, Key? key})
      : super(key: key);

  final Function() onPressedNotification;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.profileData.isNotEmpty) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CircleAvatar(backgroundImage: NetworkImage(controller.profileData['photo'] ?? '')),
          title: Text(
            controller.profileData['name'] ?? '',
            style: const TextStyle(fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            controller.profileData['email'] ?? '',
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: onPressedNotification,
            icon: const Icon(EvaIcons.bellOutline),
            tooltip: "notification",
          ),
        );
      } else {
        // Show a loading indicator or placeholder while profile data is being fetched
        return const CircularProgressIndicator();
      }
    });
  }
}
