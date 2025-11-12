import base64
from google import genai
from google.genai import types
from google.genai.types import GenerateContentConfig
from pydantic import BaseModel

ai = genai.Client()


class Recipe(BaseModel):
    title: str
    description: str
    ingredients: list[str]
    directions: list[str]
    preparationTime: int


translations = {
    "de": "Generiere das Rezept dieses Bildes auf Deutsch. Der Titel des Rezepts sollte ein kurzer Name des Gerichts sein, gefolgt von einer einfachen Textbeschreibung. Liste dann die Zutaten, die Zubereitungsanweisungen und die geschätzte Zubereitungszeit in Sekunden auf.",
    "en": "Generate the recipe from this image in English. The recipe title should be a short name of the dish, followed by a plain text description. Then, list the ingredients, preparation instructions, and estimated preparation time in seconds.",
    "es": "Genera la receta de esta imagen en español. El título de la receta debe ser un nombre corto del plato, seguido de una descripción de texto plano. Luego, enumera los ingredientes, las instrucciones para prepararlo y el tiempo estimado de preparación en segundos.",
    "fr": "Génère la recette de cette image en français. Le titre de la recette doit être un nom court du plat, suivi d'une description en texte brut. Ensuite, liste les ingrédients, les instructions de préparation et le temps de préparation estimé en secondes.",
    "it": "Genera la ricetta da questa immagine in italiano. Il titolo della ricetta dovrebbe essere un nome breve del piatto, seguito da una descrizione in testo semplice. Quindi, elenca gli ingredienti, le istruzioni per la preparazione e il tempo di preparazione stimato in secondi.",
    "ja": "この画像からレシピを日本語で生成してください。レシピのタイトルは料理の短い名前で、その後にプレーンテキストの説明を続けてください。次に、材料、準備手順、および推定準備時間を秒単位でリストアップしてください。",
    "ko": "이 이미지에서 레시피를 한국어로 생성해 주세요. 레시피 제목은 요리의 짧은 이름이어야 하며, 이어서 일반 텍스트 설명이 와야 합니다. 그 다음 재료, 준비 지침, 그리고 예상 준비 시간을 초 단위로 나열해 주세요.",
    "pt": "Gere a receita desta imagem em português. O título da receita deve ser um nome curto do prato, seguido de uma descrição em texto simples. Em seguida, liste os ingredientes, as instruções de preparo e o tempo estimado de preparação em segundos.",
    "zh": "请根据此图片生成中文食谱。食谱标题应为菜肴的简称，后跟纯文本描述。然后，列出食材、烹饪说明和预计准备时间（以秒为单位）。",
}


def generate_recipe(img: str, lang: str) -> Recipe:
    image_format = detect_image_format(img)

    response = ai.models.generate_content(
        model="gemini-2.5-flash-lite",
        contents=[
            types.Part.from_bytes(
                data=base64.b64decode(img),
                mime_type=image_format,
            ),
            translations[lang],
        ],
        config=GenerateContentConfig(
            response_mime_type="application/json",
            response_json_schema=Recipe.model_json_schema(),
        ),
    )
    return Recipe.model_validate_json(response.text)


def detect_image_format(img64: str) -> str:
    header = img64[:10]
    if header.startswith("/9j/"):
        return "image/jpeg"
    if header.startswith("iVBORw0K"):
        return "image/png"
    if header.startswith("UklGR"):
        return "image/webp"
    return "image/jpeg"
