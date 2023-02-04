project = "vaulidate"

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/wallacepf/vaulidate.git"
  }
}

pipeline "vaulidate-dev" {
    step "build"{
        use "build" {}
    }
}

app "vaulidate" {
    build {
        use "docker" {}
    }

    deploy {
        use "kubernetes" {}
    }
}