package main

import (
	"fmt"
	"os"
)

func main() {
	fmt.Println(hello(os.Getenv("APP")))
}

func hello(app string) string {
	return fmt.Sprintf("Hello from %s", app)
}
