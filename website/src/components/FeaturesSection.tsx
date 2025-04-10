export default function FeaturesSection() {
  const features = [
    {
      icon: "📱",
      title: "Funciona localmente",
      description:
        "Información almacenada en tu dispositivo, sin necesidad de internet.",
    },
    {
      icon: "📋",
      title: "Gestiona tus recetas",
      description:
        "Visualiza, añade y elimina recetas con instrucciones e ingredientes siempre a mano.",
    },
    {
      icon: "🌙",
      title: "Modo oscuro",
      description: "Tema oscuro ideal para cocinar en ambientes con poca luz.",
    },
    {
      icon: "🔄",
      title: "Próximamente: Compartir",
      description:
        "Pronto podrás compartir tus creaciones culinarias con amigos y familia.",
    },
    {
      icon: "🤖",
      title: "Próximamente: IA para recetas",
      description:
        "Generación automática de recetas a partir de imágenes con IA.",
    },
  ];

  return (
    <section
      id="features"
      className="py-20 px-5 bg-white dark:bg-zinc-900 text-center"
    >
      <h2 className="text-4xl font-bold mb-16 text-orange-600 relative">
        Características principales
        <span className="absolute bottom-[-1.5rem] left-1/2 transform -translate-x-1/2 w-20 h-1 bg-orange-600 rounded"></span>
      </h2>

      <div className="flex flex-wrap justify-center items-stretch gap-8 max-w-6xl mx-auto">
        {features.map((feature, index) => (
          <div
            key={index}
            className="flex flex-col items-center w-full sm:w-80 bg-white dark:bg-zinc-800 px-8 py-12 rounded-2xl shadow-md border border-zinc-100 dark:border-zinc-700 transition-transform duration-300 hover:-translate-y-2 hover:shadow-lg"
          >
            <div className="text-5xl mb-5 text-orange-600">{feature.icon}</div>
            <h3 className="text-xl font-bold mb-4 text-zinc-800 dark:text-zinc-100">
              {feature.title}
            </h3>
            <p className="text-zinc-600 dark:text-zinc-400 text-lg leading-relaxed">
              {feature.description}
            </p>
          </div>
        ))}
      </div>
    </section>
  );
}
