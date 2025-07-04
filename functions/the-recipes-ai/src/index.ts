import { generateRecipe } from "./generate-recipe";

export default async ({ req, res, log, error }: any) => {
  if (req.path === "/ping") {
    return res.text("Pong");
  }

  if (req.path === "/generate-recipe") {
    const { image, language } = req.body;

    if (!image || typeof image !== "string") {
      error("Invalid image format");
      return res.json(
        {
          error: "Missing or invalid image - must be a string",
        },
        400
      );
    }

    const validLanguages = [
      "de",
      "en",
      "es",
      "fr",
      "it",
      "ja",
      "ko",
      "pt",
      "zh",
    ];
    if (!language || !validLanguages.includes(language)) {
      error("Invalid language");
      return res.json(
        {
          error:
            "Missing or invalid language - must be one of: " +
            validLanguages.join(", "),
        },
        400
      );
    }

    if (Buffer.byteLength(image, "base64") > 5 * 1024 * 1024) {
      error("Image too large");
      return res.json(
        {
          error: "Image too large (>5 MB)",
        },
        400
      );
    }

    try {
      const result = await generateRecipe(image, language);
      log("Recipe generated successfully");
      return res.json(result);
    } catch (error) {
      log("Error generating recipe:", error);
      return res.json(
        {
          error: "Failed to generate recipe",
        },
        500
      );
    }
  }

  return res.json({
    msg: "The Recipes AI API is running",
  });
};
