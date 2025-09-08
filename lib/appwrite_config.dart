import "package:appwrite/appwrite.dart";

class AppwriteConfig {
  static Client? _client;
  static Account? _account;
  static TablesDB? _tables;
  static Storage? _storage;
  static Functions? _functions;

  static Client get client {
    _client ??= Client()
        .setEndpoint(AppwriteConfig.endpoint)
        .setProject(AppwriteConfig.projectId);
    return _client!;
  }

  static Account get account {
    _account ??= Account(client);
    return _account!;
  }

  static TablesDB get tables {
    _tables ??= TablesDB(client);
    return _tables!;
  }

  static Storage get storage {
    _storage ??= Storage(client);
    return _storage!;
  }

  static Functions get functions {
    _functions ??= Functions(client);
    return _functions!;
  }

  static const String projectId = "the-recipes";
  static const String endpoint = "https://nyc.cloud.appwrite.io/v1";
  static const String databaseId = "principal";
  static const String recipesTableId = "recipes";
  static const String bucketId = "recipes";
}
