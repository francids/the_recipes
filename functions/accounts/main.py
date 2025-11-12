from appwrite.client import Client
from appwrite.exception import AppwriteException
from appwrite.services.users import Users


def main(context):
    if context.req.path == "/delete":
        if "x-appwrite-user-jwt" not in context.req.headers:
            return context.res.json({"error": "Authentication required"}, 401)
        authenticated_user_id = context.req.headers["x-appwrite-user-id"]

        client = (
            Client()
            .set_endpoint("https://nyc.cloud.appwrite.io/v1")
            .set_project("the-recipes")
            .set_key(context.req.headers["x-appwrite-key"])
        )

        users = Users(client)
        try:
            users.delete(authenticated_user_id)
            context.log("User deleted successfully")
            return context.res.json({"message": "Account deleted successfully"})
        except AppwriteException as e:
            context.error("Error deleting user: ", e.message)
            return context.res.json({"error": "Failed to delete account"}, 500)

    return context.res.json({"error": "Invalid endpoint"}, 404)
