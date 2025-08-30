import { useEffect, useState, useRef, type RefObject } from "react";

interface UseElementOnScreenOptions {
  root?: RefObject<HTMLElement> | null;
  rootMargin?: string;
  threshold?: number | number[];
  triggerOnce?: boolean;
}

export default function useElementOnScreen<T extends HTMLElement>(
  options?: UseElementOnScreenOptions
): [RefObject<T | null>, boolean] {
  const containerRef = useRef<T>(null);
  const [isVisible, setIsVisible] = useState(false);

  const {
    root = null,
    rootMargin = "0px",
    threshold = 0.1,
    triggerOnce = true,
  } = options || {};

  useEffect(() => {
    const element = containerRef.current;
    if (!element) return;

    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          if (triggerOnce && element) {
            observer.unobserve(element);
          }
        } else if (!triggerOnce) {
          setIsVisible(false);
        }
      },
      {
        root: root?.current,
        rootMargin,
        threshold,
      }
    );

    observer.observe(element);

    return () => {
      if (element) {
        observer.unobserve(element);
      }
    };
  }, [containerRef, root, rootMargin, threshold, triggerOnce]);

  return [containerRef, isVisible];
}
