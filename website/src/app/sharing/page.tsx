"use client";

import { useSearchParams } from "next/navigation";
import { useEffect } from "react";
import Loading from "@/components/Loading";

export default function SharingPage() {
  const searchParams = useSearchParams();

  useEffect(() => {
    const recipeId = searchParams.get("id");
    if (recipeId) {
      window.location.replace(`the-recipes://sharing?id=${recipeId}`);
    }
  }, [searchParams]);

  const recipeId = searchParams.get("id");

  if (!recipeId) {
    return (
      <div className="flex flex-col bg-white dark:bg-zinc-900 relative min-h-screen">
        <div className="flex-1 flex items-center justify-center min-h-screen relative z-10">
          <div className="text-center px-4">
            <h1 className="text-3xl font-bold text-zinc-800 dark:text-zinc-100 mb-4">
              No recipe ID provided
            </h1>
          </div>
        </div>
      </div>
    );
  }

  return <Loading />;
}
