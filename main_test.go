package main

import (
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

// func TestMain(m *testing.M) {
// 	os.Setenv("VAULT_MODE", "file")
// 	os.Setenv("SECRET_FILE", "testdata/file.txt")
// 	os.Exit(m.Run())
// }

// func TestGetSecretFile(t *testing.T) {
// 	w := httptest.NewRecorder()
// 	c, _ := gin.CreateTestContext(w)

// 	getSecretFile(c)

// 	assert.Equal(t, http.StatusOK, w.Code)
// 	assert.Equal(t, "username=user\npassword=pass\n", w.Body.String())
// }

func TestGetSecretEnv(t *testing.T) {
	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)

	os.Setenv("USERNAME", "user")
	os.Setenv("PASSWORD", "pass")

	getSecretEnv(c)

	assert.Equal(t, http.StatusOK, w.Code)
	assert.Equal(t, "{\"user\":\"user\",\"pass\":\"pass\",\"Env\":\"Using Env Mode\"}", w.Body.String())
}
