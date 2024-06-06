local kong = kong
local oidc = require("resty.openidc")

local jwt_oidc_validate = {
  -- same default priority as openid-connect (enterprise)
  -- https://docs.konghq.com/gateway/3.4.x/plugin-development/custom-logic/#plugins-execution-order
  PRIORITY = tonumber(os.getenv("KONG_PLUGIN_PRIORITY_JWT_OIDC_VALIDATE")) or 1050,
  VERSION = "1.0.0",
}

function jwt_oidc_validate:access(conf)
local opts = {
  -- The discovery endpoint of the OP. Enable to get the URI of all endpoints (Token, introspection, logout...)
  discovery = conf.discovery_url,
  auth_accept_token_as = "header",
  auth_accept_token_as_header_name = conf.header_name,
}
-- call authenticate for OpenID Connect user authentication
local res, err = oidc.bearer_jwt_verify(opts)
if err then
  kong.response.exit(401)
end

end

return jwt_oidc_validate
