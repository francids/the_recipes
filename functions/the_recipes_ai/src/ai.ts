import OpenAI from "openai";
import type { Recipe } from "./interfaces/recipe";
import { zodResponseFormat } from "openai/helpers/zod";
import { z } from "zod";

const openai = new OpenAI({
  apiKey: process.env.GEMINI_API_KEY,
  baseURL: "https://generativelanguage.googleapis.com/v1beta/openai/"
});

const RecipeEvent = z.object({
  title: z.string(),
  description: z.string(),
  ingredients: z.array(z.string()),
  directions: z.array(z.string()),
});


export async function generateRecipeFromImage(image: File): Promise<Recipe> {
  const base64Image = Buffer.from(await image.arrayBuffer()).toString("base64");
  const response = await openai.beta.chat.completions.parse({
    model: "gemini-2.0-flash",
    messages: [
      {
        role: "user",
        content: [
          {
            type: "text",
            text: "Genera la receta de esta imagen en español",
          },
          {
            type: "image_url",
            image_url: {
              "url": `data:image/jpeg;base64,${base64Image}`
            },
          },
        ],
      },
    ],
    response_format: zodResponseFormat(RecipeEvent, "event"),
  });

  return response.choices[0].message.parsed as Recipe;
};
