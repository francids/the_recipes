"use client";

import Footer from "@/components/Footer";
import { useState, useEffect } from "react";
import Navbar from "@/components/Navbar";
import { notFound } from "next/navigation";
import { useLocale } from "next-intl";
import ReactMarkdown from "react-markdown";

export default function PrivacyPage() {
  const locale = useLocale();
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [content, setContent] = useState<string>("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
    if (!isMenuOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
  };

  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth >= 768 && isMenuOpen) {
        setIsMenuOpen(false);
        document.body.style.overflow = "";
      }
    };

    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("resize", handleResize);
      document.body.style.overflow = "";
    };
  }, [isMenuOpen]);

  useEffect(() => {
    const loadContent = async () => {
      try {
        setLoading(true);
        const response = await fetch(`/privacy/${locale}.md`);
        if (!response.ok) {
          throw new Error("Content not found");
        }
        const text = await response.text();
        setContent(text);
      } catch (err) {
        setError(true);
      } finally {
        setLoading(false);
      }
    };

    loadContent();
  }, [locale]);

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    notFound();
  }

  return (
    <div className="flex flex-col bg-white dark:bg-zinc-900">
      <div className="flex-1 min-h-screen">
        <Navbar isMenuOpen={isMenuOpen} toggleMenu={toggleMenu} />
        <div className="pt-20 pb-16 px-4 max-w-4xl mx-auto">
          <div className="prose prose-lg dark:prose-invert max-w-none break-words overflow-wrap-anywhere">
            <ReactMarkdown
              components={{
                code: ({ children, ...props }) => (
                  <code {...props} className="break-all whitespace-pre-wrap">
                    {children}
                  </code>
                ),
                pre: ({ children, ...props }) => (
                  <pre
                    {...props}
                    className="overflow-x-auto whitespace-pre-wrap break-words"
                  >
                    {children}
                  </pre>
                ),
              }}
            >
              {content}
            </ReactMarkdown>
          </div>
        </div>
      </div>
      <Footer />
    </div>
  );
}
