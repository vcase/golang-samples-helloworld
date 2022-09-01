package main

import (
	"runtime"
	"strings"
	"testing"
)

func TestHello(t *testing.T) {

	msg := greeting()

	if !strings.Contains(msg, runtime.GOOS) {
		t.Errorf("Greeting '%s' does not contain the os '%s'", msg, runtime.GOOS)
	}

	if !strings.Contains(msg, "Hello") {
		t.Errorf("Greeting '%s' does not contain '%s'", msg, "Hello")
	}
}
