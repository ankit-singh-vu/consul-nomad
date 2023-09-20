job "wordpress-app" {
  datacenters = ["dc1"]
  type = "service"

  group "wordpress-group" {
    count = 1

    // network {
    //   port "http" {
    //     to = 6380
    //   }
    // }
    network {
      mode = "bridge"

      port "http" {
        static = 80
        to     = 80
      }
    }


    task "wordpress" {
      driver = "docker"

      config {
        image = "docker.io/bitnami/laravel:10"
        // ports = ["http"]
      }

      env {
        # Set environment variables for the wordpress application
        // APP_ENV = "production"
        // APP_DEBUG = "false"
        # ...
      }

      /* volume {
        # Mount the wordpress application files into the container
        source = "./my-project"
        target = "/app"
      } */

      service {
        name = "wordpress-app"
        // port = "http"
        tags = ["wordpress"]
        // provider = "nomad"
      } 




    }
  }
}
