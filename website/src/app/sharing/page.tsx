"use client";

import { useSearchParams } from "next/navigation";
import { useEffect, useState } from "react";
import Loading from "@/components/Loading";

export default function SharingPage() {
  const searchParams = useSearchParams();
  const [showFallback, setShowFallback] = useState(false);

  useEffect(() => {
    const recipeId = searchParams.get("id");
    if (!recipeId) return;

    const isMobile =
      /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(
        navigator.userAgent
      );

    if (isMobile) {
      attemptAppRedirect(recipeId);
    } else {
      setShowFallback(true);
    }
  }, [searchParams]);

  const attemptAppRedirect = (recipeId: string) => {
    const deepLink = `the-recipes://sharing?id=${recipeId}`;
    const androidIntent = `intent://sharing?id=${recipeId}#Intent;scheme=the-recipes;package=com.francids.recipes;end`;
    const iosUniversalLink = `https://recipes.francids.com/sharing?id=${recipeId}`;

    const isAndroid = /Android/i.test(navigator.userAgent);
    const isIOS = /iPhone|iPad|iPod/i.test(navigator.userAgent);

    if (isAndroid) {
      window.location.href = androidIntent;
    } else if (isIOS) {
      window.location.href = iosUniversalLink;

      setTimeout(() => {
        window.location.href = deepLink;
      }, 1000);
    } else {
      window.location.href = deepLink;
    }

    setTimeout(() => {
      setShowFallback(true);
    }, 3000);
  };

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

  if (showFallback) {
    return (
      <div className="flex flex-col bg-white dark:bg-zinc-900 relative min-h-screen">
        <div className="flex-1 flex items-center justify-center min-h-screen relative z-10">
          <div className="text-center px-4 max-w-md">
            <p className="text-zinc-600 dark:text-zinc-400 mb-6">
              Para ver esta receta, abre la aplicación The Recipes en tu
              dispositivo móvil.
            </p>

            <div className="space-y-4">
              <button
                onClick={() =>
                  (window.location.href = `the-recipes://sharing?id=${recipeId}`)
                }
                className="w-full bg-orange-500 hover:bg-orange-600 text-white font-semibold py-3 px-6 rounded-lg transition-colors select-none "
              >
                Abrir en la App
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return <Loading />;
}
