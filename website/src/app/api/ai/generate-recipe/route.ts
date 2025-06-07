import { google } from "@ai-sdk/google";
import { generateObject } from "ai";
import { NextResponse } from "next/server";
import { z } from "zod";
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

export const maxDuration = 20;

const recipeSchema = z.object({
  title: z.string(),
  description: z.string(),
  ingredients: z.array(z.string()),
  directions: z.array(z.string()),
});

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.fixedWindow(2, "1 m"),
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

  const ip = req.headers.get("x-forwarded-for") ?? req.headers.get("host") ?? "anon";
  const { success } = await ratelimit.limit(ip);
  if (!success) {
    return NextResponse.json(
      { error: "Rate limit exceeded" },
      { status: 429, }
    );
  }

  try {
    const body = await req.json();
    const { image } = z.object({
      image: z.string(),
    }).parse(body);

    if (Buffer.byteLength(image, "base64") > 5 * 1024 * 1024) {
      return NextResponse.json(
        { error: "Image too large (>5 MB)" },
        { status: 400 },
      );
    }

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
      { error: "Error processing recipe", details: errorMessage },
      { status: 500, }
    );
  }
}
