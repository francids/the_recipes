# The Recipes AI API

## Descripción

Este directorio contiene el código fuente del API para The Recipes App. El servicio analiza imágenes de alimentos y genera recetas completas a partir de ellas.

## Características

- Analiza imágenes de platillos y genera recetas automáticamente.
- Detecta ingredientes, proporciona instrucciones y descripción del platillo.

## Tecnologías

- **Bun.js**: Entorno de ejecución y gestor de paquetes
- **Elysia.js**: Framework para API REST
- **Gemini API**: Modelo de IA para análisis de imágenes
- **TypeScript**: Lenguaje de programación tipado

## Estructura del Proyecto

```
/the_recipes_ai/
├── src/
│   ├── ai.ts              # Lógica de integración con Gemini API
│   ├── index.ts           # Punto de entrada y definición de rutas
│   └── interfaces/
│       └── recipe.ts      # Interfaces de datos para las recetas
├── .env                   # Variables de entorno (no incluido en repositorio)
├── package.json           # Configuración del proyecto y dependencias
└── tsconfig.json          # Configuración de TypeScript
```

## Instalación

1. Clona el repositorio
2. Instala Bun: `curl -fsSL https://bun.sh/install | bash`
3. Instala dependencias: `bun install`
4. Crea un archivo `.env` con tu clave API:

```
GEMINI_API_KEY=tu_clave_api_aquí
```

5. Inicia el servidor: `bun run dev`

## Uso

Endpoints disponibles:

- `GET /`: Verifica que el servicio esté funcionando
- `POST /generate-recipe`: Recibe una imagen y devuelve una receta generada

Ejemplo:

```bash
curl -X POST http://localhost:3000/generate-recipe \
  -F "image=@/ruta/a/tu/imagen.jpg"
```

Respuesta:

```json
{
  "title": "Título de la receta",
  "description": "Descripción de la receta",
  "ingredients": ["Ingrediente 1", "Ingrediente 2"],
  "directions": ["Paso 1", "Paso 2"]
}
```

## Integración

Este servicio es consumido por la aplicación móvil para generar recetas a partir de fotos tomadas por el usuario.
