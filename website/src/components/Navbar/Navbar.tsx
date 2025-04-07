import { ReactSVG } from "react-svg";
import { useEffect, useRef } from "react";
import LogoSvg from "../../assets/Logo.svg";
import styles from "./Navbar.module.css";

interface NavbarProps {
  isMenuOpen: boolean;
  toggleMenu: () => void;
  hideNavbar: boolean;
  navbarTransparent: boolean;
}

export default function Navbar({
  isMenuOpen,
  toggleMenu,
  hideNavbar,
  navbarTransparent,
}: NavbarProps) {
  const menuRef = useRef<HTMLDivElement>(null);
  const buttonRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        isMenuOpen &&
        menuRef.current &&
        buttonRef.current &&
        !menuRef.current.contains(event.target as Node) &&
        !buttonRef.current.contains(event.target as Node)
      ) {
        toggleMenu();
      }
    };

    document.addEventListener("mousedown", handleClickOutside);
    return () => {
      document.removeEventListener("mousedown", handleClickOutside);
    };
  }, [isMenuOpen, toggleMenu]);

  return (
    <nav
      className={`${styles.navbar} ${hideNavbar ? styles.navbarHidden : ""} ${
        navbarTransparent ? styles.navbarTransparent : ""
      }`}
    >
      <a href="#" className={styles.navbarLogo}>
        <ReactSVG
          src={LogoSvg}
          className={styles.navLogo}
          aria-label="The Recipes App"
        />
      </a>
      <div className={styles.navLinks}>
        <a href="#features" className={styles.navLink}>
          Características
        </a>
        <a href="#cta" className={styles.navLink}>
          Desarrollo
        </a>
        <a
          href="https://github.com/francids/the_recipes"
          target="_blank"
          rel="noopener noreferrer"
          className={styles.navLinkHighlight}
        >
          GitHub
        </a>
      </div>
      <button
        ref={buttonRef}
        className={styles.hamburgerButton}
        onClick={toggleMenu}
        aria-label="Menú"
      >
        <span className={styles.hamburgerLine}></span>
        <span className={styles.hamburgerLine}></span>
        <span className={styles.hamburgerLine}></span>
      </button>
      <div
        ref={menuRef}
        className={`${styles.mobileMenu} ${isMenuOpen ? styles.open : ""}`}
      >
        <a href="#features" className={styles.navLink} onClick={toggleMenu}>
          Características
        </a>
        <a href="#cta" className={styles.navLink} onClick={toggleMenu}>
          Desarrollo
        </a>
        <a
          href="https://github.com/francids/the_recipes"
          target="_blank"
          rel="noopener noreferrer"
          className={styles.navLinkHighlight}
          onClick={toggleMenu}
        >
          GitHub
        </a>
      </div>
    </nav>
  );
}
