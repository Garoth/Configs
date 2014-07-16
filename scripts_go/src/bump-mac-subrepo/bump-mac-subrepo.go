package main

import (
	"bytes"
	"errors"
	"flag"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/aybabtme/rgbterm"
	"github.com/codeskyblue/go-sh"
)

/** Command line variables **/
var macPathPtr = flag.String("macpath",
	os.Getenv("MAC_PROJECT_DIR"),
	"Path to the mac project\n\t(use $MAC_PROJECT_DIR)")
var relativePathToRefsFilePtr = flag.String("refsfilepath",
	"external-git/external-refs.txt",
	"Relative path to refs file")

// Runs the given git rev through git rev-parse to get the hash
func gitRevParse(rev string) (string, error) {
	out, err := sh.Command("git", "rev-parse", rev).Output()
	if err != nil {
		return "", errors.New("Couldn't parse latest git commit")
	}
	return string(out), nil
}

// Runs git diff on the given path and returns the result.
func gitDiff(projectPath string) (string, error) {
	out, err := sh.Command("git", "diff",
		"--color=always", sh.Dir(projectPath)).Output()
	if err != nil {
		return "", errors.New("Couldn't run git diff. Check repos!")
	}
	return string(out), nil
}

// Updates the given refs file for the specified project to the new hash.
func updateRefsFile(project, newHash, refsFilePath string) error {
	refsFile, err := ioutil.ReadFile(refsFilePath)
	if err != nil {
		return err
	}

	projectIndex := bytes.Index(refsFile, append([]byte{'\n'}, []byte(project)...))
	if projectIndex == -1 {
		return errors.New("Project " + project + " not found in refs file")
	}

	// index of the project name + len of project name + 1 space + matched \n
	hashIndex := projectIndex + len(project) + 2
	hashLen := len(newHash)
	updatedRefsFile := append(refsFile[0:hashIndex],
		append([]byte(newHash), refsFile[hashIndex+hashLen:]...)...)

	if err = ioutil.WriteFile(refsFilePath, updatedRefsFile, 0644); err != nil {
		return err
	}

	return nil
}

func fatal(err error) {
	fmt.Println(rgbterm.String(err.Error(), 255, 0, 0))
	os.Exit(1)
}

func main() {
	flag.Parse()
	var err error
	var project, commit string
	*macPathPtr = *macPathPtr + "/"
	refsFilePath := *macPathPtr + *relativePathToRefsFilePtr

	if len(flag.Args()) == 1 {
		project = flag.Args()[0]
		if commit, err = gitRevParse("HEAD"); err != nil {
			fatal(err)
		}
	} else if len(flag.Args()) == 2 {
		project = flag.Args()[0]
		if commit, err = gitRevParse(flag.Args()[1]); err != nil {
			fatal(err)
		}
	} else {
		fmt.Println("Positional Arguments: <project> [commit]")
		flag.PrintDefaults()
		os.Exit(1)
	}

	if info, err := os.Stat(*macPathPtr); err != nil || info.IsDir() == false {
		fatal(errors.New("Not a mac project dir: " + *macPathPtr))
	}

	if err := updateRefsFile(project, commit, refsFilePath); err != nil {
		fatal(err)
	}

	var diff string
	if diff, err = gitDiff(*macPathPtr); err != nil {
		fatal(err)
	}

	if diff == "" {
		msg := "Successfully updated file, but nothing changed."
		fmt.Println(rgbterm.String(msg, 0, 0, 230))
	} else {
		msg := "Successfully updated file. Here's the diff:"
		fmt.Println(rgbterm.String(msg, 0, 0, 230))
		fmt.Println(diff)
	}

	os.Exit(0)
}
