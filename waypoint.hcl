variable "image" {
    default = "wallacepf/vaulidate"
}

variable "tag" {
    default = "waypoint"
}

variable "registry_username" {

}

variable "registry_password" {

}

variable "git_addr" {
    default = "https://github.com/wallacepf/vaulidate.git"
}

project = "vaulidate"

runner {
  enabled = true

  data_source "git" {
    url  = "https://github.com/wallacepf/vaulidate.git"
  }
}

pipeline "vaulidate-dev" {
    // step "build"{
    //     use "build" {}
    // }
    step "test" {
        image_url = "golang:1.17"
        use "exec" {
            command = "sh"
            args = [
                "-c",
                "cd /usr/local/go/src && git clone ${var.git_addr} && cd vaulidate && go mod tidy && go test -v",
            ]
        }
    }
    step "validate-err" {
        image_url = "fdnbfbe:bfigf"
        use "exec" {
            command = "echo"
            args = [
                "12345"
            ]
        }
    }
}

app "vaulidate" {
    build {
        use "pack" {}
        registry {
            use "docker" {
                image = var.image
                tag = var.tag
                username = var.registry_username
                password = var.registry_password
                local = false
            }
        }
    }

    deploy {
        use "kubernetes" {}
    }

}