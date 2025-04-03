import styles from "./404.module.css";

export default function NotFound() {
  return (
    <div className={styles.main}>
      <h1 className={styles.title}>404 Not Found</h1>
      <p className={styles.description}>
        Oops! This page has vanished like a recipe without ingredients.
      </p>
      <button
        className={styles.button}
        onClick={() => (window.location.href = "/")}
      >
        Go to Home
      </button>
    </div>
  );
}
