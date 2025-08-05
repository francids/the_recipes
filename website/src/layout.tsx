import { useState, useEffect } from "react";
import { Outlet } from "react-router";
import { ThemeProvider } from "./contexts/ThemeContext";
import Navbar from "./components/Navbar";

export default function Layout() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

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

  return (
    <>
      <ThemeProvider>
        <Navbar isMenuOpen={isMenuOpen} toggleMenu={toggleMenu} />
        <Outlet />
      </ThemeProvider>
    </>
  );
}
