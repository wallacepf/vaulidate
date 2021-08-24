package main

import (
	"fmt"
	"os"
	"time"
)

func doEvery(d time.Duration, f func(time.Time)) {
	for x := range time.Tick(d) {
		f(x)
	}
}

func helloworld(t time.Time) {
	fmt.Printf("%v: %v\n", t, os.Getenv("SECRET"))
}

func main() {
	doEvery(1200*time.Millisecond, helloworld)
}