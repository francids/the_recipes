"use client";

import Footer from "@/components/Footer";
import { useState, useEffect } from "react";
import Navbar from "@/components/Navbar";
import { notFound } from "next/navigation";
import { useLocale } from "next-intl";
import ReactMarkdown from "react-markdown";
import Loading from "@/components/Loading";
import { useElementOnScreen } from "@/hooks/useElementOnScreen";

export default function PrivacyPage() {
  const locale = useLocale();
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [content, setContent] = useState<string>("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);

  const [contentRef, contentIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const [pageRef, pageIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const [footerRef, footerIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

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

  if (error) {
    notFound();
  }

  return (
    <div className="flex flex-col bg-white dark:bg-zinc-900 relative min-h-screen">
      <div className="absolute inset-0 bg-[linear-gradient(to_right,#f97316_1px,transparent_1px),linear-gradient(to_bottom,#f97316_1px,transparent_1px)] bg-[size:80px_80px] [mask-image:radial-gradient(ellipse_60%_60%_at_50%_50%,#000_30%,transparent_100%)] opacity-[0.008] dark:opacity-[0.012] pointer-events-none"></div>

      {loading && <Loading />}

      <div
        ref={pageRef}
        className={`flex-1 min-h-screen animate-on-scroll relative z-10 ${
          pageIsVisible ? "visible" : ""
        }`}
      >
        <Navbar isMenuOpen={isMenuOpen} toggleMenu={toggleMenu} />
        <div className="pt-20 pb-16 px-4 max-w-4xl mx-auto">
          <div
            ref={contentRef}
            className={`prose prose-lg dark:prose-invert max-w-none break-words overflow-wrap-anywhere transition-all duration-500 ease-out animate-on-scroll selection:bg-orange-500/25 ${
              loading
                ? "opacity-0"
                : contentIsVisible
                ? "visible opacity-100"
                : "opacity-0"
            }`}
            style={{ animationDelay: "0.1s" }}
          >
            <ReactMarkdown
              components={{
                h1: ({ children, ...props }) => <h1 {...props}>{children}</h1>,
                h2: ({ children, ...props }) => <h2 {...props}>{children}</h2>,
                h3: ({ children, ...props }) => <h3 {...props}>{children}</h3>,
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

      <div
        ref={footerRef}
        className={`animate-on-scroll relative z-10 ${
          footerIsVisible ? "visible" : ""
        }`}
        style={{ animationDelay: "0.2s" }}
      >
        <Footer />
      </div>
    </div>
  );
}
