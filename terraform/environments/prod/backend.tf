terraform {
  required_version = "1.16.6"

  cloud {
    
    organization = "BootheOdeg"

    workspaces {
      name = "devops-challenge"
    }
  }
}
