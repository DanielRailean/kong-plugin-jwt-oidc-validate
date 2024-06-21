-- https://github.com/zmartzone/lua-resty-openidc
local oidc = require("resty.openidc")
-- https://github.com/cdbattags/lua-resty-jwt
local jwt = require("resty.jwt")

OIDC_ISSUER_WELLKNOWN_SUFFIX = "/.well-known/openid-configuration"

local jwt_oidc_validate = {
  -- same default priority as openid-connect (enterprise)
  -- https://docs.konghq.com/gateway/3.4.x/plugin-development/custom-logic/#plugins-execution-order
  PRIORITY = tonumber(os.getenv("KONG_PLUGIN_PRIORITY_JWT_OIDC_VALIDATE")) or 1050,
  VERSION = "1.0.0",
}

function jwt_oidc_validate:access(conf)
  -- check if preflight request and whether it should be authenticated
  if not conf.run_on_preflight and kong.request.get_method() == "OPTIONS" then
    return
  end

  local discovery_url = conf.discovery_url

  if conf.use_token_issuer then
    local headers = kong.request.get_headers()
    local bearer = headers[conf.header_name]

    if not bearer then
      return kong.response.exit(401, { title = "Unauthorized" })
    end

    local words = {}
    for w in bearer:gmatch("%S+") do
      table.insert(words, w)
    end

    if not words[2] then
      return kong.response.exit(401, { title = "Unauthorized" })
    end

    local jwt_obj = jwt:load_jwt(words[2])
    local payload = jwt_obj.payload
    local issuer = payload.iss

    if not issuer then
      return kong.response.exit(401, { title = "Unauthorized" })
    end

    -- removes trailing slashes from the issuer
    issuer = issuer:gsub("%/$", "")

    discovery_url = issuer .. OIDC_ISSUER_WELLKNOWN_SUFFIX
  end

  local opts = {
    -- The discovery endpoint of the OP. Enable to get the URI of all endpoints (Token, introspection, logout...)
    discovery = discovery_url,
    auth_accept_token_as = "header",
    auth_accept_token_as_header_name = conf.header_name,
  }

  -- call authenticate for OpenID Connect user authentication
  local res, err = oidc.bearer_jwt_verify(opts)
  if err then
    kong.log.err(err)
    return kong.response.exit(401, { title = "Unauthorized" })
  end
end

return jwt_oidc_validate
