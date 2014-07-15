package main

import (
	"bytes"
	"errors"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"

	"github.com/aybabtme/rgbterm"
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
	cmd := exec.Command("git", "rev-parse", rev)
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return "", errors.New("Couldn't parse latest git commit")
	}
	result := out.String()
	return result, nil
}

// Runs git diff on the given path and returns the result.
func gitDiff(projectPath string) (string, error) {
	cmd := exec.Command("git", "diff")
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Dir = *macPathPtr
	if err := cmd.Run(); err != nil {
		return "", errors.New("Couldn't run git diff. Check repos!")
	}
	return out.String(), nil
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
