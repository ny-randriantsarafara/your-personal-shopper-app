class WorkspaceConfig {
  const WorkspaceConfig({
    required this.publicName,
    required this.defaultLanguage,
    required this.primaryColorHex,
  });

  final String publicName;
  final String defaultLanguage;
  final String primaryColorHex;
}
