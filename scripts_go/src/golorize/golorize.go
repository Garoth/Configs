package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"regexp"
	"strings"

	"github.com/aybabtme/rgbterm"
)

var configFilePath = flag.String("conf", "colorconf.json",
	"Path to configuration file to use")
var configuration Configuration

type Color struct {
	R, G, B uint8
}

type Replacement struct {
	Match, Replace string
}

type Instruction struct {
	LineRegex        string
	Replacements     []Replacement
	ClipLine         int
	ColorTargetRegex string
	Color            Color
}

type Configuration struct {
	Instructions []Instruction
}

func ApplyRules(input string) string {
	for _, instruction := range configuration.Instructions {
		lineRegex := regexp.MustCompile(instruction.LineRegex)

		if lineRegex.MatchString(input) {

			for _, replacement := range instruction.Replacements {
				repMatch := regexp.MustCompile(replacement.Match)
				input = repMatch.ReplaceAllString(input, replacement.Replace)
			}

			if instruction.ClipLine > 0 && len(input) > instruction.ClipLine {
				input = input[0:instruction.ClipLine]
				input = input + rgbterm.String("»", 150, 150, 150)
			}

			if instruction.ColorTargetRegex != "" {
				colorTargetRegex := regexp.MustCompile("(" +
					instruction.ColorTargetRegex + ")")

				input = colorTargetRegex.ReplaceAllString(input,
					rgbterm.String("$1",
						instruction.Color.R,
						instruction.Color.G,
						instruction.Color.B))
			}
		}
	}

	return input
}

func main() {
	flag.Parse()

	var err error
	var configFile *os.File

	if configFile, err = os.Open(*configFilePath); err != nil {
		log.Fatalln("Couldn't read config file:", err)
	}
	defer configFile.Close()

	decoder := json.NewDecoder(configFile)
	configuration = Configuration{}

	if err = decoder.Decode(&configuration); err != nil {
		log.Fatalln("Couldn't parse config file:", err)
	}

	backupFile, err := ioutil.TempFile("", "golorize-backup-")
	if err != nil {
		log.Fatalln("Couldn't create temporary backup file")
	}
	backupFileName := backupFile.Name()
	defer backupFile.Close()
	fmt.Println("The backup file for this golorize session is:")
	fmt.Println("   ", backupFileName)
	fmt.Println("")

	bufferedInput := bufio.NewReader(os.Stdin)
	var str string
	for true {
		str, err = bufferedInput.ReadString('\n')

		if err == io.EOF {
			break
		} else if err != nil {
			log.Println("Error reading line from stdin:", err)
		}

		prettyStr := ApplyRules(str)
		fmt.Println(strings.Replace(prettyStr, "\n", "", -1))
		backupFile.WriteString(str)
	}

	fmt.Println()
	fmt.Println("The backup file for this golorize session is:")
	fmt.Println("   ", backupFileName)
}
