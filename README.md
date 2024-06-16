# kong-plugin-jwt-oidc-validate

A basic replacement for [Kong OpenID Connect Enterprise plugin](https://docs.konghq.com/hub/kong-inc/openid-connect/).

Performs OIDC token validation using an OIDC discovery endpoint. It verifies tokens based on either the provided `discovery_url` or the token issuer, ensuring secure and compliant authentication.

The configuration options include specifying the header name that contains the token and choosing between the discovery URL or token issuer for validation.

## features

- can be configured to use the token issuer, thus allowing access to multiple issuers to the same resource (other plugins needed to configure allowed issuers. Coming soon)
- simple with low memory footprint

## limitations

- only access token auth flow supported. [support list for kong openid plugin.](https://docs.konghq.com/hub/kong-inc/openid-connect/#authentication-flows-and-grants)

## Configuration

| Parameter          | Type     | Required | Default        | Description                                                                 |
|--------------------|----------|----------|----------------|-----------------------------------------------------------------------------|
| `discovery_url`    | string   | No*       | None           | The URL for the OIDC discovery endpoint.                                    |
| `use_token_issuer` | boolean  | No*       | None           | Flag to use the token issuer for validation instead of the `discovery_url`                                              |
| `header_name`      | string   | Yes      | `authorization` | The name of the header that contains the token.                             |

\* either `discovery_url` or `use_token_issuer` must be configured, but not both.
