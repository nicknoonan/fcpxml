package main

import (
	// "os"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"github.com/nicknoonan/fcpxml/src/parser"
	"github.com/gin-gonic/gin"
    "github.com/gin-gonic/autotls"
	"github.com/joho/godotenv"
  	"golang.org/x/crypto/acme/autocert"
)

func main() {
	config := loadConfig()
	router := gin.Default()
	router.Static("/", config.assets)
	router.POST("/api/upload", func(c *gin.Context) {
		// Single file
		file, err := c.FormFile("fcpxml")
		if (err != nil) {
			c.String(http.StatusBadRequest, "no form file \"fcpxml\" was found")
			log.Println(err)
			return
		}
		opened, err := file.Open()
		if (err != nil) {
			c.String(http.StatusBadRequest, err.Error())
			log.Println(err)
			return
		}
		fileBytes, err := io.ReadAll(opened)
		if (err != nil) {
			c.String(http.StatusBadRequest, err.Error())
			log.Println(err)
			return
		}
		// log.Println(file.Filename)
		// log.Println(string(fileBytes))

		fileContents := string(fileBytes)
		timeStamps, err := parser.Parse(fileContents)
		if (err != nil) {
			c.String(http.StatusInternalServerError, err.Error())
			log.Println(err)
			return
		}
	
		c.String(http.StatusOK, timeStamps)
	})
	if (config.host == "localhost") {
		log.Fatal(router.Run(fmt.Sprintf(":%s",config.port)))
	} else {
		certManager := autocert.Manager{
			Prompt:     autocert.AcceptTOS,
			HostPolicy: autocert.HostWhitelist(config.host),
			Cache:      autocert.DirCache("/app/.cache"),
		}
		log.Println(certManager.HostPolicy)
		log.Fatal(autotls.RunWithManager(router, &certManager))
	}
}

func loadConfig() Config {
	godotenv.Load()
	return Config{
		port: os.Getenv("PORT"),
		assets: os.Getenv("ASSETS"),
		host: os.Getenv("FCPXML_HOST"),
	}
}