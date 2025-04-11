import type { Metadata } from "next";
import { Open_Sans } from "next/font/google";
import "./globals.css";

const openSans = Open_Sans({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "The Recipes",
  description:
    "Tu libro de recetas digital - Almacena, organiza y encuentra fácilmente todas tus recetas favoritas",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="es">
      <body className={openSans.className}>{children}</body>
    </html>
  );
}
