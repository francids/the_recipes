# The Recipes App

<img src="./assets/TheRecipesApp%20-%20Presentation.png" alt="TheRecipesApp">

The Recipes App es una aplicación móvil enfocada en recetas. The Recipes App le permite al usuario revisar sus recetas,
agregar nuevas y eliminar algunas.

## Directorios

- **android**: Contiene el código fuente de la aplicación móvil para Android.
- **assets**: Contiene los recursos de la aplicación móvil y del repositorio.
- **lib**: Contiene el código fuente de la aplicación móvil.
- **website**: Contiene el código fuente de la página web.

## Flujo de trabajo

1. El usuario inicia sesión en la aplicación móvil con su cuenta de Google.
2. El usuario visualiza las recetas creadas por él mismo.
3. El usuario puede agregar una nueva receta.
4. El usuario puede eliminar una receta.
5. El usuario puede hacer pública una receta y compartirla con un amigo mediante un enlace.
6. El amigo puede visualizar la receta compartida en la página web mediante el enlace.

## Tecnologías

- **Flutter**.
- **Dart**.
- **Firebase**.
- **GetX**.

## Instalación

1. Clonar el repositorio.
2. Ejecutar `flutter pub get` para instalar las dependencias.
3. Crear un proyecto en Firebase e instalar el CLI de Firebase: `npm install -g firebase-tools`.
4. Iniciar sesión con `firebase login`.
5. Configurar la aplicación con Firebase: `flutterfire configure`.
6. Ejecutar la aplicación: `flutter run`.
