import Footer from "@/components/Footer";
import Recipe from "@/interfaces/recipe";
import { notFound } from "next/navigation";

async function getRecipe(id: string): Promise<Recipe | null> {
  const res = await fetch(process.env.URL + "/api/recipe?id=" + id);
  if (res.status === 404) {
    return null;
  }
  return res.json();
}

export default async function RecipePage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const recipe = await getRecipe(id);

  if (!recipe) {
    notFound();
  }

  return (
    <div className="flex flex-col">
      <div className="flex-1 min-h-screen p-0 m-0 flex flex-col items-center justify-center gap-2 px-5 text-white bg-gradient-to-br from-orange-600 to-orange-400">
        <h1 className="text-center mb-0 text-4xl font-bold">{recipe.title}</h1>
        <p className="text-center max-w-[600px] mt-0">{recipe.description}</p>
        <p className="text-center max-w-[400px] mt-3 text-sm text-white/80 italic">
          Recipe details coming soon. We&apos;re preparing the format for
          ingredients and instructions.
        </p>
      </div>
      <Footer />
    </div>
  );
}
