"use client";

import { useState, useEffect } from "react";
import Navbar from "@/components/Navbar";
import HeroSection from "@/components/HeroSection";
import FeaturesSection from "@/components/FeaturesSection";
import CTASection from "@/components/CTASection";
import Footer from "@/components/Footer";
import ScrollTopButton from "@/components/ScrollTopButton";

export default function Home() {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [showScrollTop, setShowScrollTop] = useState(false);
  const [lastScrollY, setLastScrollY] = useState(0);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
    if (!isMenuOpen) {
      document.body.style.overflow = "hidden";
    } else {
      document.body.style.overflow = "";
    }
  };

  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;

      if (currentScrollY > 300) {
        setShowScrollTop(true);
      } else {
        setShowScrollTop(false);
      }

      setLastScrollY(currentScrollY);
    };

    const handleResize = () => {
      // Cerrar el menú automáticamente si la pantalla se redimensiona a tamaño desktop
      if (window.innerWidth >= 768 && isMenuOpen) {
        setIsMenuOpen(false);
        document.body.style.overflow = "";
      }
    };

    window.addEventListener("scroll", handleScroll);
    window.addEventListener("resize", handleResize);

    return () => {
      window.removeEventListener("scroll", handleScroll);
      window.removeEventListener("resize", handleResize);
      // Asegurar que el scroll esté habilitado cuando el componente se desmonta
      document.body.style.overflow = "";
    };
  }, [lastScrollY, isMenuOpen]);

  return (
    <div className={`min-h-screen ${isMenuOpen ? "relative" : ""}`}>
      <Navbar isMenuOpen={isMenuOpen} toggleMenu={toggleMenu} />
      <HeroSection />
      <FeaturesSection />
      <CTASection />
      <Footer />
      <ScrollTopButton showScrollTop={showScrollTop} />
    </div>
  );
}
