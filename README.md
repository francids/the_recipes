<img src="./assets/Logo.svg" width="100">

# The Recipes App

**The Recipes** es una aplicación móvil enfocada en recetas. The Recipes App le permite al usuario revisar sus recetas, agregar nuevas y eliminar algunas.

## Funcionalidades de la aplicación

- [x] **Gestión de recetas**: El usuario puede agregar, visualizar y eliminar recetas.
- [x] **Funcionalidad local**: La aplicación permite al usuario gestionar sus recetas sin necesidad de conexión a Internet.
- [x] **Modo oscuro**: La aplicación cuenta con un modo oscuro para mejorar la experiencia del usuario en condiciones de poca luz.
- [x] **Soporte multi-idioma**: La aplicación está disponible en varios idiomas (Alemán, Chino, Coreano, Español, Francés, Inglés, Italiano, Japonés, Portugués).
- [x] **Compartición de recetas**: El usuario puede compartir sus recetas con otros usuarios a través de un enlace único.
- [ ] **IA**: La aplicación utiliza inteligencia artificial para:
  - [x] Generar recetas basadas en una foto de un plato.
  - [ ] Sugerir recetas basadas en los ingredientes que el usuario tiene en casa.
  - [ ] Sugerir recetas basadas en las preferencias del usuario.

## Estructura del proyecto

El repositorio está organizado en tres carpetas principales:

- **`lib/`**: Contiene el código fuente de la aplicación móvil Flutter, incluyendo controladores, modelos, vistas y configuraciones de la app.
- **`website/`**: Sitio web desarrollado en Next.js que presenta la aplicación y maneja la funcionalidad de compartir recetas a través de enlaces únicos.
- **`functions/`**: Funciones serverless de Appwrite que proporcionan servicios de backend para la gestión de cuentas y funcionalidades de IA.

## Tecnologías utilizadas

- La aplicación móvil está desarrollada en [Flutter](https://flutter.dev/) con [Hive CE](https://pub.dev/packages/hive_ce) y [GetX](https://pub.dev/packages/get).
- El sitio web está desarrollado en [Next.js](https://nextjs.org/) con [Tailwind CSS](https://tailwindcss.com/) y [Bun](https://bun.sh/).
- Las funciones serverless están desarrolladas en [Bun](https://bun.sh/) y se ejecutan en [Appwrite Functions](https://appwrite.io/docs/functions). Las funciones de IA utilizan [AI SDK](https://sdk.vercel.ai/) y [Gemini](https://ai.google.dev/).
- La aplicación móvil usa [Appwrite](https://appwrite.io/) para la autenticación de usuarios, almacenamiento de recetas y demás.
