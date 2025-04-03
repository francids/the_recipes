import styles from "./404.module.css";
import Footer from "../components/Footer";

export default function NotFound() {
  return (
    <div className={styles.container}>
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
      <Footer />
    </div>
  );
}
