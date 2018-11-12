package main

import (
	"testing"
)

func TestCreateTodo(t *testing.T) {
	if hello("test") != "Hello from test" {
		t.Fail()
	}
}
