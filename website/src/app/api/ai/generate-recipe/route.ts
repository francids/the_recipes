import { google } from "@ai-sdk/google";
import { generateObject } from "ai";
import { NextResponse } from "next/server";
import { z } from "zod";
import { Ratelimit } from "@upstash/ratelimit";
import { Redis } from "@upstash/redis";

export const maxDuration = 20;

const recipeSchema = z.object({
  title: z.string().max(50),
  description: z.string(),
  ingredients: z.array(z.string()),
  directions: z.array(z.string()),
});

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.fixedWindow(2, "1 m"),
});

const translations: Record<string, string> = {
  "de": "Generiere das Rezept dieses Bildes auf Deutsch. Der Titel des Rezepts sollte ein kurzer Name des Gerichts sein, gefolgt von einer einfachen Textbeschreibung. Liste dann die Zutaten und die Zubereitungsanweisungen auf.",
  "en": "Generate the recipe from this image in English. The recipe title should be a short name of the dish, followed by a plain text description. Then, list the ingredients and preparation instructions.",
  "es": "Genera la receta de esta imagen en español. El título de la receta debe ser un nombre corto del plato, seguido de una descripción de texto plano. Luego, enumera los ingredientes y las instrucciones para prepararlo.",
  "fr": "Génère la recette de cette image en français. Le titre de la recette doit être un nom court du plat, suivi d'une description en texte brut. Ensuite, liste les ingrédients et les instructions de préparation.",
  "it": "Genera la ricetta da questa immagine in italiano. Il titolo della ricetta dovrebbe essere un nome breve del piatto, seguito da una descrizione in testo semplice. Quindi, elenca gli ingredienti e le istruzioni per la preparazione.",
  "ja": "この画像からレシピを日本語で生成してください。レシピのタイトルは料理の短い名前で、その後にプレーンテキストの説明を続けてください。次に、材料と準備手順をリストアップしてください。",
  "ko": "이 이미지에서 레시피를 한국어로 생성해 주세요. 레시피 제목은 요리의 짧은 이름이어야 하며, 이어서 일반 텍스트 설명이 와야 합니다. 그 다음 재료와 준비 지침을 나열해 주세요.",
  "pt": "Gere a receita desta imagem em português. O título da receita deve ser um nome curto do prato, seguido de uma descrição em texto simples. Em seguida, liste os ingredientes e as instruções de preparo.",
  "zh": "请根据此图片生成中文食谱。食谱标题应为菜肴的简称，后跟纯文本描述。然后，列出食材和烹饪说明。"
};

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
    const { image, language } = z.object({
      image: z.string(),
      language: z.enum(["de", "en", "es", "fr", "it", "ja", "ko", "pt", "zh"]).default("en"),
    }).parse(body);

    if (Buffer.byteLength(image, "base64") > 5 * 1024 * 1024) {
      return NextResponse.json(
        { error: "Image too large (>5 MB)" },
        { status: 400 },
      );
    }

    const messageText = translations[language];

    const { object } = await generateObject({
      model: google("models/gemini-2.0-flash"),
      schema: recipeSchema,
      messages: [
        {
          role: "user",
          content: [
            {
              type: "image",
              image: image,
            },
            {
              type: "text",
              text: messageText,
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
