import base64

from generate import generate_recipe

MAX_IMAGE_SIZE_BYTES = 5 * 1024 * 1024

VALID_LANGUAGES = [
    "de",
    "en",
    "es",
    "fr",
    "it",
    "ja",
    "ko",
    "pt",
    "zh",
]


def main(context):
    if context.req.path == "/generate-recipe":
        try:
            data = context.req.body_json
            image = data["image"]
            language = data["language"]

        except Exception as e:
            context.error(f"Error parsing JSON: {e}")
            return context.res.json({"error": "Invalid JSON format"}, 400)

        if not isinstance(image, str) or not image:
            context.error("Invalid image format")
            return context.res.json(
                {
                    "error": "Missing or invalid image - must be a base64 string",
                },
                400,
            )

        if not language or language not in VALID_LANGUAGES:
            context.error("Invalid language")
            return context.res.json(
                {
                    "error": (
                        "Missing or invalid language - must be one of: "
                        + ", ".join(VALID_LANGUAGES)
                    ),
                },
                400,
            )

        try:
            image_bytes = base64.b64decode(image, validate=True)
        except Exception as e:
            context.error(f"Image is not a valid base64 string: {e}")
            return context.res.json(
                {
                    "error": "Image is not a valid base64 string",
                },
                400,
            )

        if len(image_bytes) > MAX_IMAGE_SIZE_BYTES:
            context.error("Image too large")
            return context.res.json(
                {
                    "error": "Image too large (>5 MB)",
                },
                400,
            )

        try:
            recipe = generate_recipe(image, language)
            context.log("Recipe generated successfully")
            return context.res.json(recipe.model_dump())
        except Exception as e:
            context.error(f"Error generating recipe: {e}")
            return context.res.json(
                {
                    "error": "Failed to generate recipe",
                },
                500,
            )

    return context.res.json({"error": "Invalid endpoint"}, 404)
