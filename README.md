# The Recipes App

The Recipes App es una aplicación móvil enfocada en recetas. The Recipes App le permite al usuario revisar sus recetas, agregar nuevas y eliminar algunas.

## Funcionalidades

- [x] **Gestión de recetas**: El usuario puede agregar, visualizar y eliminar recetas.
- [x] **Funcionalidad local**: La aplicación permite al usuario gestionar sus recetas sin necesidad de conexión a Internet.
- [x] **Modo oscuro**: La aplicación cuenta con un modo oscuro para mejorar la experiencia del usuario en condiciones de poca luz.
- [x] **Soporte multi-idioma**: La aplicación está disponible en varios idiomas (Alemán, Chino, Coreano, Español, Francés, Inglés, Italiano, Japonés, Portugués).
- [ ] **Compartición de recetas**: El usuario puede compartir sus recetas con otros usuarios a través de un enlace único.
- [ ] **IA**: La aplicación utiliza inteligencia artificial para:
  - [ ] Generar recetas basadas en una foto de un plato.
  - [ ] Sugerir recetas basadas en los ingredientes que el usuario tiene en casa.
  - [ ] Sugerir recetas basadas en las preferencias del usuario.

## Directorios

- **lib/**: Contiene el código fuente de la aplicación móvil desarrollada en Flutter.
- **website/**: Contiene el código fuente de la página web; incluye visualizar recetas compartidas, API's de IA y la página de inicio.

## Tecnologías

La aplicación móvil está desarrollada en [Flutter](https://flutter.dev/) con [Hive CE](https://pub.dev/packages/hive_ce) y [GetX](https://pub.dev/packages/get).

La página web está desarrollada en [Next.js](https://nextjs.org/) con [Tailwind CSS](https://tailwindcss.com/) y [Bun](https://bun.sh/). Las funcionalidades de IA están desarrolladas con [AI SDK](https://sdk.vercel.ai/) y [Gemini](https://ai.google.dev/); adicionalmente, se utiliza [Upstash Redis](https://upstash.com/) para el cacheo de las peticiones a la API de IA.

Tanto la aplicación móvil como la página web usan [Firebase](https://firebase.google.com/) para la autenticación de usuarios y el almacenamiento de recetas en la nube.
