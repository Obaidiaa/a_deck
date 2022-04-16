// data model for deck command

class Command {
  Command({
    required this.id,
    required this.name,
    required this.command,
    required this.picture,
  });

  final String id;
  final String name;
  final String command;
  final String picture;
}
