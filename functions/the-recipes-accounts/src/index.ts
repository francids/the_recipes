import { Client, Users } from "node-appwrite";

export default async ({ req, res, log, error }: any) => {
  if (req.path === "/delete") {
    if (!req.headers["x-appwrite-user-jwt"]) {
      return res.json({ error: "Authentication required" }, 401);
    }

    const authenticatedUserId = req.headers["x-appwrite-user-id"];

    const client = new Client()
      .setEndpoint("https://nyc.cloud.appwrite.io/v1")
      .setProject("the-recipes")
      .setKey(req.headers["x-appwrite-key"]);

    const users = new Users(client);

    try {
      await users.delete(authenticatedUserId);
      log("User deleted successfully:", authenticatedUserId);

      return res.json({
        success: true,
        message: "Account deleted successfully",
      });
    } catch (deleteError: any) {
      error("Error deleting user:", deleteError);
      return res.json(
        {
          error: "Failed to delete account",
        },
        500
      );
    }
  }

  return res.json({ error: "Invalid endpoint" }, 404);
};
