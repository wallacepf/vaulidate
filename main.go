package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/hashicorp/vault/api"
)

var vaultMode string = os.Getenv("VAULT_MODE")

var output struct {
	Username string `json:"user"`
	Password string `json:"pass"`
}

func getSecretFile(c *gin.Context) {
	var filePath string = os.Getenv("SECRET_FILE")
	data, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Fatal(err)
	}

	c.JSON(http.StatusOK, string(data))
}

func getSecretNative(c *gin.Context) {
	var vaultAddr string = os.Getenv("VAULT_ADDR")
	var secretPath string = os.Getenv("SECRET_PATH")
	config := &api.Config{
		Address: vaultAddr,
	}
	client, err := api.NewClient(config)
	if err != nil {
		log.Fatal(err)
		return
	}

	roleID := os.Getenv("ROLE_ID")
	secretID := os.Getenv("SECRET_ID")

	params := map[string]interface{}{
		"role_id":   roleID,
		"secret_id": secretID,
	}

	resp, err := client.Logical().Write("auth/approle/login", params)
	if err != nil {
		log.Fatal(err)
	}
	client.SetToken(resp.Auth.ClientToken)
	secret, err := client.Logical().Read(secretPath)
	if err != nil {
		log.Fatal(err)
	}
	data, ok := secret.Data["data"].(map[string]interface{})
	if !ok {
		log.Fatalf("data type assertion failed: %T %#v", secret.Data["data"], secret.Data["data"])
	}
	keyA, keyB := "username", "password"
	output.Username, output.Password = data[keyA].(string), data[keyB].(string)

	c.JSON(http.StatusOK, output)
}

func getSecretEnv(c *gin.Context) {
	output.Username = os.Getenv("USERNAME")
	output.Password = os.Getenv("PASSWORD")
	c.JSON(http.StatusOK, output)
}

func main() {
	router := gin.Default()

	switch vaultMode {
	case "native":
		router.GET("/", getSecretNative)
	case "env":
		router.GET("/", getSecretEnv)
	case "file":
		router.GET("/", getSecretFile)
	default:
		router.GET("/", getSecretEnv)
	}

	router.Run("0.0.0.0:8080")
}
