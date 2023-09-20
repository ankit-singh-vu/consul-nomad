/* job "example" {
  group "app" {
    //count = 3 
    task "web" {
      driver = "docker"

      config {
        image = "hashicorpdev/counter-api:v3"
      }
    }
    scaling {
      min     = 2
      max     = 10
      enabled = true

      policy {
        evaluation_interval = "5s"
        cooldown            = "1m"

        check "active_connections" {
          source = "prometheus"
          query  = "scalar(open_connections_example_cache)"

          strategy "target-value" {
            target = 10
          }
        }
      }
    }
  }
} */


job "wordpress-app" {
  datacenters = ["dc1"]
  type = "service"

  group "wordpress-group" {
    count = 1





    /* scaling {
      min     = 1
      max     = 10
      enabled = true

      policy {
        evaluation_interval = "5s"
        cooldown            = "1m"

        check "active_connections" {
          source = "prometheus"
          query  = "scalar(open_connections_example_cache)"

          strategy "target-value" {
            target = 10
          }
        }
      }
    } */

    // network {
    //   port "http" {
    //     to = 6380
    //   }
    // }
    network {
      mode = "bridge"

      port "http" {
        /* static = 80 */
        to     = 80
      }
    }

    scaling {
      enabled = true
      min     = 1
      max     = 20

      policy {
        cooldown = "30s"

        check "avg_sessions" {
          source = "prometheus"
          query  = "avg(nomad_client_allocs_memory_usage{exported_job=\"wordpress-app\"})/1000000"

          strategy "target-value" {
            target = 250
          }
        }
      }
    }

    task "wordpress" {
      driver = "docker"

      config {
        image = "wordpress:6.2.0-apache"
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
        source = "./app"
        target = "/var/www/html"
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
