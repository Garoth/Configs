package main

import (
	"bytes"
	"errors"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

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
	return string(out[0 : len(out)-1]), err
}

// Produces list of git commits from old hash to new hash. Filters out
// merge commits.
func gitCommitsSince(oldHash, newHash string) (string, error) {
	out, err := sh.Command("git", "log", "--no-merges", "--pretty=%h %s",
		oldHash+".."+newHash).Output()
	return string(out), err
}

// Runs git diff on the given path and returns the result.
func gitDiff(projectPath string) (string, error) {
	out, err := sh.Command("git", "diff",
		"--color=always", sh.Dir(projectPath)).Output()
	return string(out), err
}

// Commits all the local changes in the given repo with the given message
func gitCommit(projectPath, message string) error {
	_, err := sh.Command("git", "commit", "-a", "-s", "-m"+message,
		sh.Dir(projectPath)).Output()
	return err
}

// Updates the given refs file for the specified project to the new hash.
// Returns the old hash that was replaced.
func updateRefsFile(project, newHash, refsFilePath string) (string, error) {
	refsFile, err := ioutil.ReadFile(refsFilePath)
	if err != nil {
		return "", err
	}

	projectIndex := bytes.Index(refsFile,
		append([]byte{'\n'}, []byte(project)...))

	if projectIndex == -1 {
		return "", errors.New("Project " + project + " not found in refs file")
	}

	// index of the project name + len of project name + 1 space + matched \n
	hashIndex := projectIndex + len(project) + 2
	hashLen := len(newHash)
	oldHash := string(refsFile[hashIndex : hashIndex+hashLen-1])
	updatedRefsFile := append(refsFile[0:hashIndex],
		append([]byte(newHash), refsFile[hashIndex+hashLen:]...)...)

	if err = ioutil.WriteFile(refsFilePath, updatedRefsFile, 0644); err != nil {
		return "", err
	}

	return string(oldHash), nil
}

func fatal(err error) {
	fmt.Println(rgbterm.String(err.Error(), 255, 0, 0, 0, 0, 0))
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

	oldCommit, err := updateRefsFile(project, commit, refsFilePath)
	if err != nil {
		fatal(err)
	}

	var diff string
	if diff, err = gitDiff(*macPathPtr); err != nil {
		fatal(err)
	}

	if diff == "" {
		msg := "--- Successfully updated file, but nothing changed ---"
		fmt.Println(rgbterm.String(msg, 114, 138, 4, 0, 0, 0))
		os.Exit(0)
	}

	msg := "--- Successfully updated file. Here's the diff ---\n"
	fmt.Println(rgbterm.String(msg, 114, 138, 4, 0, 0, 0))
	fmt.Println("    " + strings.Replace(diff, "\n", "\n    ", -1))

	commits, err := gitCommitsSince(oldCommit, commit)
	if err == nil {
		msg = "--- And here are the commits that were added ---\n"
		fmt.Println(rgbterm.String(msg, 114, 138, 4, 0, 0, 0))
		fmt.Println("    " + strings.Replace(commits, "\n", "\n    ", -1))
	}

	msg = "--- Lets get this show on the road. Make commit? (y/n) ---\n"
	fmt.Println(rgbterm.String(msg, 114, 138, 4, 0, 0, 0))
	commitMessage := "Bump for the " + project + " subrepository\n\n" +
		"Changes since the last version:\n" + "    " +
		strings.Replace(commits, "\n", "\n    ", -1)
	fmt.Println(commitMessage)

	fmt.Printf("> ")
	var input string
	_, err = fmt.Scanf("%s", &input)
	if err != nil || (input != "y" && input != "n") {
		fmt.Println("Invalid input; good luck with that. Bye.")
		os.Exit(1)
	}

	if input == "y" {
		gitCommit(*macPathPtr, commitMessage)
	} else if input == "n" {
		fmt.Println("Bye.")
		os.Exit(0)
	}

	os.Exit(0)
}
