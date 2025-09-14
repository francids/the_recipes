import { useState, useEffect } from "react";
import ReactMarkdown from "react-markdown";
import Loading from "@/components/Loading";
import { useElementOnScreen } from "@/hooks";
import { useTranslation } from "react-i18next";

export default function PrivacyPage() {
  const { i18n } = useTranslation();
  const [content, setContent] = useState<string>("");
  const [status, setStatus] = useState<"loading" | "success" | "error">(
    "loading"
  );

  const [contentRef, contentIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  const [pageRef, pageIsVisible] = useElementOnScreen<HTMLDivElement>({
    threshold: 0.1,
    triggerOnce: true,
  });

  useEffect(() => {
    const loadContent = async () => {
      try {
        setStatus("loading");
        const modules = import.meta.glob("../assets/privacy/*.md", {
          import: "default",
          query: "?raw",
          eager: true,
        });
        const filePath = `../assets/privacy/${i18n.language}.md`;

        if (modules[filePath]) {
          setContent(modules[filePath] as string);
        } else {
          setContent(modules["../assets/privacy/en.md"] as string);
        }
        setStatus("success");
      } catch {
        setStatus("error");
      }
    };

    loadContent();
  }, [i18n.language]);

  if (status === "error") {
    console.error("Error loading privacy content");
  }

  return (
    <div className="flex flex-col bg-white dark:bg-zinc-900 relative min-h-screen">
      <div className="absolute inset-0 bg-[linear-gradient(to_right,#f97316_1px,transparent_1px),linear-gradient(to_bottom,#f97316_1px,transparent_1px)] bg-[size:80px_80px] [mask-image:radial-gradient(ellipse_60%_60%_at_50%_50%,#000_30%,transparent_100%)] opacity-[0.008] dark:opacity-[0.012] pointer-events-none"></div>

      {status === "loading" && <Loading />}

      <div ref={pageRef} className="flex-1 min-h-screen relative z-10">
        <div
          className={`pt-20 pb-16 px-4 max-w-4xl mx-auto animate-on-scroll ${
            pageIsVisible ? "visible" : ""
          }`}
        >
          <div
            ref={contentRef}
            className={`prose prose-lg dark:prose-invert max-w-none break-words overflow-wrap-anywhere transition-all duration-500 ease-out animate-on-scroll selection:bg-orange-500/25 ${
              status === "loading"
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
    </div>
  );
}
