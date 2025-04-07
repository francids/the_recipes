import styles from "./ScrollTopButton.module.css";

interface ScrollTopButtonProps {
  showScrollTop: boolean;
}

export default function ScrollTopButton({
  showScrollTop,
}: ScrollTopButtonProps) {
  const scrollToTop = () => {
    window.scrollTo({
      top: 0,
      behavior: "smooth",
    });
  };

  if (!showScrollTop) {
    return null;
  }

  return (
    <button
      className={styles.scrollTopButton}
      onClick={scrollToTop}
      aria-label="Volver arriba"
    >
      <svg
        xmlns="http://www.w3.org/2000/svg"
        height="24px"
        viewBox="0 -960 960 960"
        width="24px"
        fill="currentColor"
      >
        <path d="M440-160v-487L216-423l-56-57 320-320 320 320-56 57-224-224v487h-80Z" />
      </svg>
    </button>
  );
}
