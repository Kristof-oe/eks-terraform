resource "kubernetes_config_map" "app_variable" {
  metadata {
    name = "app-variable"
  }

  data = {
    DB_HOST : aws_db_instance.postgres.address
    POSTGRES_USER : "djangouser"
    POSTGRES_DB : "postgres"

    DEBUG : "1"
    SECRET_KEY : "kris"
    DJANGO_ALLOWED_HOSTS : "*"
    DJANGO_ADMIN_USER : "kris"
    DJANGO_ADMIN_EMAIL : "admin@exa.com"
    DATABASE : "postgres"
    DB_ENGINE : "django.db.backends.postgresql"
    DB_DATABASE : "postgres"
    DB_USER : "djangouser"
    DB_PORT : "5432"

  }

  depends_on = [aws_db_instance.postgres]

}