import { Elysia, t } from "elysia";
import { generateRecipeFromImage } from "./ai";

const app = new Elysia();

class Logger {
  log(value: string) {
    console.log(value)
  }
}

app.decorate('logger', new Logger());

app.get(
  "/",
  () => "Hello, The Recipes AI",
);

app.post(
  "/generate-recipe",
  async ({ body, set }) => {
    try {
      console.log("Received request body:", body);
      const { image } = body;

      if (!image) {
        set.status = 400;
        return { error: "No se ha proporcionado una imagen" };
      }

      const recipe = await generateRecipeFromImage(image);
      return recipe;
    } catch (error: any) {
      console.error("Error processing recipe:", error);
      set.status = 500;
      return { error: "Error al procesar la receta", details: error.message };
    }
  },
  {
    body: t.Object({
      image: t.File(),
    }),
  },
);

app.listen(process.env.PORT || 3000);

console.log(
  `The Recipes AI is running at ${app.server?.hostname}:${app.server?.port}`
);
