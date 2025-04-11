"use client";

import Footer from "@/components/Footer";
import { useRouter } from "next/navigation";
import Button from "@/components/Button";

export default function NotFound() {
  const router = useRouter();

  return (
    <div className="flex flex-col">
      <div className="flex-1 min-h-screen p-0 m-0 flex flex-col items-center justify-center gap-2 px-5 text-white bg-gradient-to-br from-orange-600 to-orange-400">
        <h1 className="text-center mb-0 text-4xl font-bold">404 Not Found</h1>
        <p className="text-center max-w-[600px] mt-0">
          Oops! This page has vanished like a recipe without ingredients.
        </p>
        <Button onClick={() => router.push("/")}>Go to Home</Button>
      </div>
      <Footer />
    </div>
  );
}
