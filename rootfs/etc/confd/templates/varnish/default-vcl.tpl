vcl 4.0;

backend default {
    .host = "{{getv "/varnish/backend"}}";
    .port = "{{getv "/varnish/backend/port"}}";
}