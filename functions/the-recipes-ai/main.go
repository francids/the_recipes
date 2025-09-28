package therecipesaigo

import (
	"encoding/base64"
	"net/http"
	"strings"

	"github.com/open-runtimes/types-for-go/v4/openruntimes"
)

type MainResponse struct {
	Msg string `json:"msg"`
}

type GenerateRecipeRequest struct {
	Image    string `json:"image"`
	Language string `json:"language"`
}

type Recipe struct {
	Title           string   `json:"title"`
	Description     string   `json:"description"`
	Ingredients     []string `json:"ingredients"`
	Directions      []string `json:"directions"`
	PreparationTime int      `json:"preparationTime"`
}

type ErrorResponse struct {
	Error string `json:"error"`
}

func Main(Context openruntimes.Context) openruntimes.Response {
	if Context.Req.Path == "/ping" {
		return Context.Res.Text(
			"pong",
			Context.Res.WithStatusCode(http.StatusOK),
		)
	}

	if Context.Req.Path == "/generate-recipe" {
		var req GenerateRecipeRequest
		err := Context.Req.BodyJson(&req)
		if err != nil {
			Context.Error(err.Error())
			return Context.Res.Json(
				ErrorResponse{
					Error: "Invalid JSON body",
				},
				Context.Res.WithStatusCode(http.StatusBadRequest),
			)
		}

		if req.Image == "" || !isValidBase64(req.Image) {
			Context.Error("Missing or invalid image")
			return Context.Res.Json(
				ErrorResponse{
					Error: "Missing or invalid image - must be a base64 string",
				},
				Context.Res.WithStatusCode(http.StatusBadRequest),
			)
		}

		validLanguages := []string{"de", "en", "es", "fr", "it", "ja", "ko", "pt", "zh"}
		if req.Language == "" || !contains(validLanguages, req.Language) {
			Context.Error("Missing or invalid language")
			return Context.Res.Json(
				ErrorResponse{
					Error: "Missing or invalid language - must be one of: " + strings.Join(validLanguages, ", "),
				},
				Context.Res.WithStatusCode(http.StatusBadRequest),
			)
		}

		if base64.StdEncoding.DecodedLen(len(req.Image)) > 5*1024*1024 {
			Context.Error("Image too large")
			return Context.Res.Json(
				ErrorResponse{
					Error: "Image too large (>5 MB)",
				},
				Context.Res.WithStatusCode(http.StatusBadRequest),
			)
		}

		recipe, err := generateRecipe(req.Image, req.Language)
		if err != nil {
			Context.Error("Error generating recipe: " + err.Error())
			return Context.Res.Json(
				ErrorResponse{
					Error: "Failed to generate recipe",
				},
				Context.Res.WithStatusCode(http.StatusInternalServerError),
			)
		}

		Context.Log("Recipe generated successfully")
		return Context.Res.Json(
			recipe,
			Context.Res.WithStatusCode(http.StatusOK),
		)
	}

	return Context.Res.Json(
		MainResponse{
			Msg: "The Recipes AI is running",
		},
		Context.Res.WithStatusCode(http.StatusOK),
	)
}

func isValidBase64(s string) bool {
	_, err := base64.StdEncoding.DecodeString(s)
	return err == nil
}

func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}
