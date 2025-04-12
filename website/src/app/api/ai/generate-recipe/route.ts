import { google } from "@ai-sdk/google";
import { generateObject } from "ai";
import { NextResponse } from "next/server";
import { z } from "zod";

export const maxDuration = 20;

const recipeSchema = z.object({
  title: z.string(),
  description: z.string(),
  ingredients: z.array(z.string()),
  directions: z.array(z.string()),
});

export async function POST(req: Request) {
  const secretKey = req.headers.get("TRA-SECRET-KEY");

  if (!secretKey) {
    return NextResponse.json(
      { error: "Missing secret key" },
      { status: 401, }
    );
  }

  const expectedKey = process.env.TRA_SECRET_KEY;

  if (secretKey !== expectedKey) {
    return NextResponse.json(
      { error: "Invalid secret key" },
      { status: 401, }
    );
  }

  try {
    const body = await req.json();
    const { image } = z.object({
      image: z.string(),
    }).parse(body);

    const { object } = await generateObject({
      model: google("models/gemini-2.0-flash"),
      schema: recipeSchema,
      messages: [
        {
          role: "user",
          content: [
            {
              type: 'image',
              image: image,
            },
            {
              type: "text",
              text: "Genera la receta de esta imagen en español. El título de la receta debe ser un nombre corto del plato, seguido de una descripción de texto plano. Luego, enumera los ingredientes y las instrucciones para prepararlo.",
            },

          ],
        },
      ],
    });

    return NextResponse.json(
      object,
      { status: 200, }
    );
  } catch (error) {
    console.error("Error processing recipe:", error);
    const errorMessage = error instanceof Error ? error.message : String(error);
    return NextResponse.json(
      { error: "Error al procesar la receta", details: errorMessage },
      { status: 500, }
    );
  }
}
