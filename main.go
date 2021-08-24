package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
)

func getSecret(c *gin.Context) {
	var output struct {
		Username string `json:"user"`
		Password string `json:"pass"`
	}
	output.Username = os.Getenv("USERNAME")
	output.Password = os.Getenv("PASSWORD")
	c.JSON(http.StatusOK, output)
}

func main() {
	router := gin.Default()
	router.GET("/secret", getSecret)
	router.Run("0.0.0.0:8080")
}
