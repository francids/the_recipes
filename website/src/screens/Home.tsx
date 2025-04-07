import { useState, useEffect } from "react";
import styles from "./Home.module.css";
import Navbar from "../components/Navbar/Navbar";
import HeroSection from "../components/HeroSection/HeroSection";
import FeaturesSection from "../components/FeaturesSection/FeaturesSection";
import CTASection from "../components/CTASection/CTASection";
import ScrollTopButton from "../components/ScrollTopButton/ScrollTopButton";
import Footer from "../components/Footer";

export default function Home() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [showScrollTop, setShowScrollTop] = useState(false);
  const [hideNavbar, setHideNavbar] = useState(false);
  const [navbarTransparent, setNavbarTransparent] = useState(true);
  const [lastScrollY, setLastScrollY] = useState(0);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;

      if (currentScrollY > 300) {
        setShowScrollTop(true);
      } else {
        setShowScrollTop(false);
      }

      if (currentScrollY > lastScrollY && currentScrollY > 100) {
        setHideNavbar(true);
      } else {
        setHideNavbar(false);
      }

      if (currentScrollY < 50) {
        setNavbarTransparent(true);
      } else {
        setNavbarTransparent(false);
      }

      setLastScrollY(currentScrollY);
    };

    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, [lastScrollY]);

  const features = [
    {
      icon: "📱",
      title: "Funciona localmente",
      description:
        "Toda la información se almacena en tu dispositivo, sin necesidad de conexión a internet para acceder a tus recetas.",
    },
    {
      icon: "📋",
      title: "Gestiona tus recetas",
      description:
        "Visualiza, añade y elimina recetas fácilmente. Instrucciones paso a paso e ingredientes siempre a mano cuando los necesites.",
    },
    {
      icon: "🌙",
      title: "Modo oscuro",
      description:
        "Disfruta de la aplicación con un tema oscuro, perfecto para cocinar en ambientes con poca luz o para cuidar tus ojos.",
    },
    {
      icon: "🔄",
      title: "Próximamente: Compartir",
      description:
        "En futuras versiones, podrás compartir tus mejores creaciones culinarias con amigos y familiares.",
    },
    {
      icon: "🤖",
      title: "Próximamente: IA para recetas",
      description:
        "En futuras versiones, podrás generar automáticamente la información de una receta a partir de una imagen utilizando inteligencia artificial.",
    },
  ];

  return (
    <div className={styles.container}>
      <Navbar
        isMenuOpen={isMenuOpen}
        toggleMenu={toggleMenu}
        hideNavbar={hideNavbar}
        navbarTransparent={navbarTransparent}
      />
      <HeroSection />
      <FeaturesSection features={features} />
      <CTASection />
      <Footer />
      <ScrollTopButton showScrollTop={showScrollTop} />
    </div>
  );
}
