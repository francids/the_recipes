import type { Metadata } from "next";
import { Open_Sans } from "next/font/google";
import "./globals.css";

import { NextIntlClientProvider } from "next-intl";
import { getLocale } from "next-intl/server";

const openSans = Open_Sans({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "The Recipes",
  description:
    "Tu libro de recetas digital - Almacena, organiza y encuentra fácilmente todas tus recetas favoritas",
};

export default async function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const locale = await getLocale();

  return (
    <html lang={locale}>
      <body className={openSans.className}>
        <NextIntlClientProvider>{children}</NextIntlClientProvider>
      </body>
    </html>
  );
}
