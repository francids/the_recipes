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
          Descargar
        </a>
        <a
          href="https://github.com/francids/the_recipes"
          target="_blank"
          rel="noopener noreferrer"
          className={styles.navLink}
        >
          GitHub
        </a>
        <a
          href="https://the-recipe-app.uptodown.com/android"
          target="_blank"
          rel="noopener noreferrer"
          className={styles.navLinkHighlight}
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            height="24px"
            viewBox="0 -960 960 960"
            width="24px"
            fill="currentColor"
          >
            <path d="M40-240q9-107 65.5-197T256-580l-74-128q-6-9-3-19t13-15q8-5 18-2t16 12l74 128q86-36 180-36t180 36l74-128q6-9 16-12t18 2q10 5 13 15t-3 19l-74 128q94 53 150.5 143T920-240H40Zm240-110q21 0 35.5-14.5T330-400q0-21-14.5-35.5T280-450q-21 0-35.5 14.5T230-400q0 21 14.5 35.5T280-350Zm400 0q21 0 35.5-14.5T730-400q0-21-14.5-35.5T680-450q-21 0-35.5 14.5T630-400q0 21 14.5 35.5T680-350Z" />
          </svg>
          <span>Descargar ahora</span>
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
          Descargar
        </a>
        <a
          href="https://github.com/francids/the_recipes"
          target="_blank"
          rel="noopener noreferrer"
          className={styles.navLink}
          onClick={toggleMenu}
        >
          GitHub
        </a>
        <a
          href="https://the-recipe-app.uptodown.com/android"
          target="_blank"
          rel="noopener noreferrer"
          className={styles.navLinkHighlight}
          onClick={toggleMenu}
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            height="24px"
            viewBox="0 -960 960 960"
            width="24px"
            fill="currentColor"
          >
            <path d="M40-240q9-107 65.5-197T256-580l-74-128q-6-9-3-19t13-15q8-5 18-2t16 12l74 128q86-36 180-36t180 36l74-128q6-9 16-12t18 2q10 5 13 15t-3 19l-74 128q94 53 150.5 143T920-240H40Zm240-110q21 0 35.5-14.5T330-400q0-21-14.5-35.5T280-450q-21 0-35.5 14.5T230-400q0 21 14.5 35.5T280-350Zm400 0q21 0 35.5-14.5T730-400q0-21-14.5-35.5T680-450q-21 0-35.5 14.5T630-400q0 21 14.5 35.5T680-350Z" />
          </svg>
          <span>Descargar ahora</span>
        </a>
      </div>
    </nav>
  );
}
