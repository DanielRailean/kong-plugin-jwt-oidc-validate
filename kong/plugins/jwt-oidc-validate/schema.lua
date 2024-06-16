local PLUGIN_NAME = "kong-plugin-jwt-oidc-validate"

local schema = {
  name = PLUGIN_NAME,
  fields = {
    {
      config = {
        type = "record",
        fields = {
          {
            discovery_url = {
              type = "string",
              required = false,
            }
          },
          {
            use_token_issuer = {
              type = "boolean",
              required = false,
            }
          },
          {
            header_name = {
              type = "string",
              required = true,
              default = "authorization"
            }
          },
        },
        entity_checks = {
          {
            mutually_exclusive = {
              "discovery_url",
              "use_token_issuer",
            },
          },
          {
            at_least_one_of = {
              "discovery_url",
              "use_token_issuer",
            }
          }
        }
      },
    },
  },
}

return schema
