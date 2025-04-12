import { type NextRequest, NextResponse } from "next/server";
import { db } from "@/lib/firebase";
import { getDoc, doc } from "firebase/firestore";

export async function GET(request: NextRequest): Promise<NextResponse> {
  try {
    const recipeId = request.nextUrl.searchParams.get("id");
    if (!recipeId) {
      return NextResponse.json(
        { error: "Recipe ID is required" },
        { status: 400 }
      );
    }

    const docRef = doc(db, "recipes", recipeId);
    const docSnap = await getDoc(docRef);

    if (!docSnap.exists()) {
      return NextResponse.json(
        { error: "Recipe not found" },
        { status: 404 }
      );
    }

    return NextResponse.json(
      docSnap.data(),
      { status: 200 },
    );
  } catch (error) {
    console.error("Error fetching recipes:", error);
    return NextResponse.json(
      { error: "Failed to fetch recipes" },
      { status: 500 }
    );
  }
}
