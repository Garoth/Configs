package main

import (
	"bytes"
	"errors"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
)

/** Command line variables **/
var macPathPtr = flag.String("macpath",
	os.Getenv("MAC_PROJECT_DIR")+"/",
	"Path to the mac project")
var relativePathToRefsFilePtr = flag.String("refsfilepath",
	"external-git/external-refs.txt",
	"Relative path to refs file")

// Returns the latest git commit in the current directory
func parseLatestCommit() (string, error) {
	cmd := exec.Command("git", "rev-parse", "HEAD")
	var out bytes.Buffer
	cmd.Stdout = &out
	err := cmd.Run()
	if err != nil {
		return "", errors.New("Couldn't parse latest git commit")
	}
	result := out.String()
	return result, nil
}

func main() {
	flag.Parse()
	var project, commit string

	if len(flag.Args()) == 1 {
		project = flag.Args()[0]
		var err error
		commit, err = parseLatestCommit()
		if err != nil {
			panic(err)
		}
	} else if len(flag.Args()) == 2 {
		project = flag.Args()[0]
		commit = flag.Args()[1]
	} else {
		fmt.Println("Positional Arguments: <project> [commit]")
		flag.PrintDefaults()
		os.Exit(1)
	}

	if info, err := os.Stat(*macPathPtr); err != nil || info.IsDir() == false {
		fmt.Println("Not the mac project dir:", *macPathPtr)
		os.Exit(1)
	}

	refsFile, err := ioutil.ReadFile(*macPathPtr + *relativePathToRefsFilePtr)
	if err != nil {
		panic(err)
	}

	projectIndex := bytes.Index(refsFile, append([]byte{'\n'}, []byte(project)...))
	if projectIndex == -1 {
		panic("Project " + project + " not found in refs file")
	}

	// index of the project name + len of project name + 1 space + matched \n
	hashIndex := projectIndex + len(project) + 2
	hashLen := len(commit)
	updatedRefsFile := append(refsFile[0:hashIndex],
		append([]byte(commit), refsFile[hashIndex+hashLen:]...)...)

	if err = ioutil.WriteFile(*macPathPtr+*relativePathToRefsFilePtr,
		updatedRefsFile, 0644); err != nil {
		panic(err)
	}

	fmt.Println("Success. Here's the diff:")

	cmd := exec.Command("git", "diff")
	var out bytes.Buffer
	cmd.Stdout = &out
	cmd.Dir = *macPathPtr
	if err = cmd.Run(); err != nil {
		panic("Couldn't run diff on resulting command")
	}
	fmt.Println(out.String())
}
