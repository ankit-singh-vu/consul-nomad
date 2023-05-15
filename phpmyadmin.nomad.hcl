job "phpmyadmin-app" {
  datacenters = ["dc1"]
  type = "service"

  group "phpmyadmin-group" {
    count = 1

    /* network {
      port "http" {
        to = 8500
        // static = 8500
      }
    } */
    network {
      mode = "bridge"

      port "http" {
        static = 80
        to     = 80
      }
    }


    task "phpmyadmin" {
      driver = "docker"

      config {
        image = "phpmyadmin/phpmyadmin:5.0"
        /* ports = ["http"] */
      }

      env {
        # Set environment variables for the PHP application
        APP_ENV = "production"
        APP_DEBUG = "false"
        # ...
      }

      /* volume {
        # Mount the PHP application files into the container
        source = "./app"
        target = "/var/www/html"
      } */

      service {
        name = "phpmyadmin-app"
        /* port = "http" */
        tags = ["phpmyadmin"]
        // provider = "nomad"
      }




    }
  }
}
