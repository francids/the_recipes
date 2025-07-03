import "package:appwrite/appwrite.dart";

class AppwriteConfig {
  static Client? _client;
  static Account? _account;
  static Databases? _databases;
  static Storage? _storage;

  static Client get client {
    _client ??= Client()
        .setEndpoint("https://nyc.cloud.appwrite.io/v1")
        .setProject("the-recipes");
    return _client!;
  }

  static Account get account {
    _account ??= Account(client);
    return _account!;
  }

  static Databases get databases {
    _databases ??= Databases(client);
    return _databases!;
  }

  static Storage get storage {
    _storage ??= Storage(client);
    return _storage!;
  }

  static const String databaseId = "principal";
  static const String recipesCollectionId = "recipes";
  static const String bucketId = "recipes";

  static const String redirectUrlSuccess =
      "https://cloud.appwrite.io/console/auth/oauth2/success";
  static const String redirectUrlFailure =
      "https://cloud.appwrite.io/console/auth/oauth2/failure";
}
