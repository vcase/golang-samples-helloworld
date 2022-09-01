package main

import (
	"fmt"
	"runtime"
)

func main() {

	fmt.Println(greeting())
}

func greeting() string {
	return fmt.Sprintf("Hello from %s!", runtime.GOOS)
}
