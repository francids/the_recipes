# The Recipes Website

## Desarrollo

Para iniciar el proyecto, se debe tener:

- [Bun](https://bun.sh/) instalado.
- Tener la base de datos de Upstash Redis creada y configurada. Puede ser desde [Upstash](https://upstash.com/) o desde [Vercel](https://vercel.com/docs/redis).
- Tener un proyecto de [Firebase](https://console.firebase.google.com/) creado y configurado.
- Tener una API Key de un proveedor de IA. Este proyecto está configurado para usar [Gemini](https://ai.google.dev/), pero usa [AI SDK](https://sdk.vercel.ai/) para la integración.

Revisa el archivo `.env.example` para más información sobre las variables de entorno necesarias para el proyecto.

## Instalación

1. Clona el repositorio:

```bash
git clone https://github.com/francids/the_recipes.git
cd the_recipes/website
```

2. Instala las dependencias:

```bash
bun install
```

3. Crear el archivo `.env` a partir del archivo `.env.example` y configura las variables de entorno necesarias.

```bash
cp .env.example .env
```

4. Inicia el servidor de desarrollo:

```bash
bun dev
```

5. Abre tu navegador y visita `http://localhost:3000` para ver la aplicación en funcionamiento.
