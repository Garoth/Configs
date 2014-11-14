package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"regexp"

	"github.com/codeskyblue/go-sh"
)

// Calls git log on the given hash-ish object. Ex. HEAD~5..
func gitLog(hashish string) (string, error) {
	out, err := sh.Command("git", "log", hashish).Output()
	return string(out), err
}

// Prints URLs found inside of the given text
func printURLs(text string) {
	// Yeah, not an amazing regex, but works here
	re := regexp.MustCompile("https://gerrit.*[0-9]+")
	results := re.FindAllString(text, -1)

	if results == nil || len(results) == 0 {
		fmt.Println("Couldn't find any URLs. Exiting.")
		os.Exit(0)
	}

	for _, str := range results {
		fmt.Println(str)
	}
}

func main() {
	flag.Parse()

	if len(flag.Args()) == 0 {
		text, err := gitLog("HEAD~1..")

		if err != nil {
			log.Fatalln("Couldn't get git log", err)
		}

		printURLs(text)
	} else if len(flag.Args()) == 1 {
		text, err := gitLog(flag.Args()[0])

		if err != nil {
			log.Fatalln("Couldn't get git log", err)
		}

		printURLs(text)
	} else {
		fmt.Println("Usage:")
		fmt.Println("git-gerrit-urls [git hash-ish string]")
		flag.PrintDefaults()
		os.Exit(1)
	}
}
