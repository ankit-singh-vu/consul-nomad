job "mysql-app" {
  datacenters = ["dc1"]
  type = "service"

  group "mysql-group" {
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
        static = 3306
        to     = 3306
      }
    }


    task "mysql" {
      driver = "docker"

      config {
        image = "mysql:5.7"
        /* ports = ["http"] */
      }

      env {
        # Set environment variables for the PHP application
        MYSQL_ROOT_PASSWORD = "admin"
        # ...
      }

      /* volume {
        # Mount the PHP application files into the container
        source = "./app"
        target = "/var/www/html"
      } */

      service {
        name = "mysql-app"
        /* port = "http" */
        tags = ["mysql"]
        // provider = "nomad"
      }




    }
  }
}
