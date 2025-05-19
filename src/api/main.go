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
	"github.com/joho/godotenv"
)

func main() {
	config := loadConfig()
	router := gin.Default()
	router.Static("/", config.assets)
	router.POST("/upload", func(c *gin.Context) {
		// Single file
		file, err := c.FormFile("fcpxml")
		if (err != nil) {
			c.String(http.StatusBadRequest, "no form file \"fcpxml\" was found")
			log.Println(err)
			return;
		}
		opened, err := file.Open()
		if (err != nil) {
			c.String(http.StatusBadRequest, err.Error())
			log.Println(err)
			return;
		}
		fileBytes, err := io.ReadAll(opened)
		if (err != nil) {
			c.String(http.StatusBadRequest, err.Error())
			log.Println(err)
			return;
		}
		// log.Println(file.Filename)
		// log.Println(string(fileBytes))

		fileContents := string(fileBytes)
		timeStamps, err := parser.Parse(fileContents)
		if (err != nil) {
			c.String(http.StatusInternalServerError, err.Error())
			log.Fatal(err)
		}
	
		c.String(http.StatusOK, timeStamps)
	})
	router.Run(fmt.Sprintf(":%s",config.port))
}

func loadConfig() Config {
	godotenv.Load()
	return Config{
		port: os.Getenv("PORT"),
		assets: os.Getenv("ASSETS"),
	}
}